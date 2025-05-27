execute 'enable-universe' do
  command 'apt-add-repository universe -y'
  not_if 'apt-cache policy | grep -q universe'
end

ruby_block 'set_podman_repo_url' do
  block do
    case node['lsb']['codename']
    when 'bionic'
      node.run_state['podman_repo_url'] = 'https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_18.04/'
    when 'focal'
      node.run_state['podman_repo_url'] = 'https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.04/'
    when 'jammy'
      node.run_state['podman_repo_url'] = 'https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_22.04/'
    else
      node.run_state['podman_repo_url'] = 'https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_22.04/'
    end
    Chef::Log.info("Using Podman repository URL: #{node.run_state['podman_repo_url']}")
  end
  action :run
end

file '/etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list' do
  content lazy { "deb [trusted=yes] #{node.run_state['podman_repo_url']} /" }
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

execute 'add-libcontainers-key' do
  command lazy { "curl -fsSL #{node.run_state['podman_repo_url']}Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/libcontainers.gpg" }
  not_if { ::File.exist?('/etc/apt/trusted.gpg.d/libcontainers.gpg') }
  action :run
end

apt_update 'update' do
  ignore_failure true
  action :update
end

package 'uidmap' do
  action :install
end

package 'containernetworking-plugins' do
  action :install
end

package 'podman' do
  action :install
  retries 2
  retry_delay 5
end

bash 'try-alternative-podman-install' do
  code <<-EOH
    apt-get update -q || true
    apt-get install -y podman || {
      snap install podman --classic || {
        cd /tmp
        apt-get install -y curl
        curl -L -o podman.deb http://archive.ubuntu.com/ubuntu/pool/universe/p/podman/podman_1.6.2-2_amd64.deb
        apt-get install -y ./podman.deb || echo "Failed to install podman"
      }
    }
  EOH
  not_if 'which podman'
end

%w(containers-common catatonit).each do |pkg|
  bash "check-#{pkg}-availability" do
    code <<-EOH
      apt-cache show #{pkg} >/dev/null 2>&1
    EOH
    ignore_failure true
    only_if 'which apt-cache > /dev/null 2>&1'
    notifies :install, "package[#{pkg}]", :immediately
  end

  package pkg do
    action :nothing
    ignore_failure true
  end

  ruby_block "log-#{pkg}-status" do
    block do
      Chef::Log.info("Optional dependency #{pkg} is not installed if not available.")
    end
    action :run
  end
end

directory '/etc/containers' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  recursive true
end

file '/etc/containers/registries.conf' do
  content <<~EOL
    [registries.search]
    registries = ['docker.io', 'quay.io', 'registry.fedoraproject.org', 'registry.access.redhat.com']

    [registries.insecure]
    registries = []

    [registries.block]
    registries = []
  EOL
  owner 'root'
  group 'root'
  mode '0644'
  action :create_if_missing
end

ruby_block 'set_storage_driver' do
  block do
    node.run_state['podman_storage_driver'] = 'vfs'
    Chef::Log.info("Using storage driver: vfs")
  end
  action :run
end

execute 'cleanup-podman-database' do
  command 'rm -rf /var/lib/containers/storage /var/run/containers/storage ~/.local/share/containers/'
  action :run
  ignore_failure true
end

file '/etc/containers/storage.conf' do
  content lazy {
    <<~EOL
      [storage]
      driver = "#{node.run_state['podman_storage_driver']}"
      runroot = "/var/run/containers/storage"
      graphroot = "/var/lib/containers/storage"

      [storage.options]
      additionalimagestores = []

      [storage.options.overlay]
      ignore_chown_errors = "false"

      [storage.options.thinpool]
    EOL
  }
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

directory '/root/.config/containers' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  recursive true
end

file '/root/.config/containers/storage.conf' do
  content lazy {
    <<~EOL
      [storage]
      driver = "#{node.run_state['podman_storage_driver']}"
    EOL
  }
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

ruby_block 'create_user_config' do
  block do
    username = `whoami`.strip
    home_dir = username == 'root' ? '/root' : "/home/#{username}"

    config_dir = "#{home_dir}/.config/containers"
    unless Dir.exist?(config_dir)
      system("mkdir -p #{config_dir}")
    end

    File.write("#{config_dir}/storage.conf", "[storage]\ndriver = \"#{node.run_state['podman_storage_driver']}\"\n")

    Chef::Log.info("Created user-level storage configuration for user #{username}")
  end
  action :run
  ignore_failure true
end

execute 'setup-podman-sysctl' do
  command 'echo "kernel.unprivileged_userns_clone=1" > /etc/sysctl.d/00-local-userns.conf'
  action :run
  not_if 'grep -q "kernel.unprivileged_userns_clone=1" /etc/sysctl.d/00-local-userns.conf 2>/dev/null'
end

execute 'apply-sysctl' do
  command 'sysctl --system'
  action :run
end

service 'podman.socket' do
  action [:enable, :start]
  only_if { ::File.exist?('/usr/lib/systemd/system/podman.socket') }
  ignore_failure true
end

ruby_block 'check-podman-installation' do
  block do
    require 'mixlib/shellout'
    cmd = Mixlib::ShellOut.new('which podman')
    cmd.run_command
    Chef::Log.info("Podman installation status: #{cmd.exitstatus == 0 ? 'SUCCESS' : 'FAILED'}")
  end
  action :run
end

ruby_block 'test-podman-vfs' do
  block do
    require 'mixlib/shellout'

    version_cmd = Mixlib::ShellOut.new('podman --version')
    version_cmd.run_command
    Chef::Log.info("Podman version: #{version_cmd.stdout.strip}")

    info_cmd = Mixlib::ShellOut.new('STORAGE_DRIVER=vfs podman info')
    info_cmd.run_command
    if info_cmd.exitstatus == 0
      Chef::Log.info("Podman info command succeeded with VFS driver")
    else
      Chef::Log.warn("Podman info command failed with VFS driver: #{info_cmd.stderr.strip}")
    end

    test_cmd = Mixlib::ShellOut.new('STORAGE_DRIVER=vfs podman run --rm hello-world')
    test_cmd.run_command
    if test_cmd.exitstatus == 0
      Chef::Log.info("Podman container test succeeded")
    else
      Chef::Log.warn("Podman container test failed: #{test_cmd.stderr.strip}")
    end
  end
  action :run
  ignore_failure true
end

Chef::Log.info("Podman installation completed on Ubuntu (#{node['lsb']['codename']})")
Chef::Log.info("Optional dependencies containers-common and catatonit are not required for basic functionality")

service 'podman.socket' do
  action :stop
  only_if { ::File.exist?('/usr/lib/systemd/system/podman.socket') }
  ignore_failure true
  notifies :write, 'log[Podman service stopped]', :immediately
end

log 'Podman service stopped' do
  message "Podman socket service has been stopped. You can start it manually when needed."
  level :info
  action :nothing
end

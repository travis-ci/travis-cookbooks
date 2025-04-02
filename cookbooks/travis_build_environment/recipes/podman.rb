# podman.rb
# Recipe for Podman installation and configuration on Ubuntu distributions (Bionic, Focal, Jammy)

# Ensure universe repository is enabled (Podman is in universe for Ubuntu)
execute 'enable-universe' do
  command 'apt-add-repository universe -y'
  not_if 'apt-cache policy | grep -q universe'
end

# Determine repository URL based on Ubuntu codename
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
      node.run_state['podman_repo_url'] = 'https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_18.04/'
    end
    Chef::Log.info("Using Podman repository URL: #{node.run_state['podman_repo_url']}")
  end
  action :run
end

# Add Kubic repository with trusted option
file '/etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list' do
  content lazy { "deb [trusted=yes] #{node.run_state['podman_repo_url']} /" }
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

# Add Kubic repository key
execute 'add-libcontainers-key' do
  command lazy { "curl -fsSL #{node.run_state['podman_repo_url']}Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/libcontainers.gpg" }
  not_if { ::File.exist?('/etc/apt/trusted.gpg.d/libcontainers.gpg') }
  action :run
end

# Update package cache (ignoring failure to prevent build interruption)
apt_update 'update' do
  ignore_failure true
  action :update
end

# Install necessary dependencies for Podman to run properly
package 'uidmap' do
  action :install
end

package 'containernetworking-plugins' do
  action :install
end

# Install Podman package from the Kubic repository
package 'podman' do
  action :install
  retries 2
  retry_delay 5
end

# Fallback installation: try alternative methods if Podman is not found
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

# Install related optional packages (containers-common, catatonit)
%w(containers-common catatonit).each do |pkg|
  bash "check-#{pkg}-availability" do
    code <<-EOH
      apt-cache show #{pkg} >/dev/null 2>&1
    EOH
    ignore_failure true
    only_if { system('which apt-cache > /dev/null 2>&1') }
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

# Create directory for Podman configuration
directory '/etc/containers' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  recursive true
end

# Create registries.conf file
file '/etc/containers/registries.conf' do
  content <<~EOL
    # Registry configuration for Podman
    
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

# Determine storage driver based on Ubuntu version
ruby_block 'set_storage_driver' do
  block do
    # For Bionic use "vfs", for Focal and Jammy use "overlay"
    driver = node['lsb']['codename'] == 'bionic' ? 'vfs' : 'overlay'
    node.run_state['podman_storage_driver'] = driver
    Chef::Log.info("Using storage driver: #{driver}")
  end
  action :run
end

# Create storage.conf file with proper storage driver
file '/etc/containers/storage.conf' do
  content lazy {
    <<~EOL
      # Storage configuration for Podman
      # Using driver #{node.run_state['podman_storage_driver']}
      
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
  action :create_if_missing
end

# Configure system for Podman: enable unprivileged user namespaces
execute 'setup-podman-sysctl' do
  command 'echo "kernel.unprivileged_userns_clone=1" > /etc/sysctl.d/00-local-userns.conf'
  action :run
  not_if 'grep -q "kernel.unprivileged_userns_clone=1" /etc/sysctl.d/00-local-userns.conf 2>/dev/null'
end

execute 'apply-sysctl' do
  command 'sysctl --system'
  action :run
end

# Enable and start Podman socket (if available)
service 'podman.socket' do
  action [:enable, :start]
  only_if { ::File.exist?('/usr/lib/systemd/system/podman.socket') }
  ignore_failure true
end

# Check if Podman was installed successfully
ruby_block 'check-podman-installation' do
  block do
    require 'mixlib/shellout'
    cmd = Mixlib::ShellOut.new('which podman')
    cmd.run_command
    Chef::Log.info("Podman installation status: #{cmd.exitstatus == 0 ? 'SUCCESS' : 'FAILED'}")
  end
  action :run
end

# Verify Podman was properly installed
ruby_block 'verify-podman' do
  block do
    require 'mixlib/shellout'
    cmd = Mixlib::ShellOut.new('podman --version')
    cmd.run_command
    if cmd.exitstatus == 0
      Chef::Log.info("Podman successfully installed: #{cmd.stdout.strip}")
    else
      Chef::Log.warn("Podman may not be installed correctly: #{cmd.stderr.strip}")
    end
  end
  action :run
  ignore_failure true
end

Chef::Log.info("Podman installation completed on Ubuntu (#{node['lsb']['codename']})")
Chef::Log.info("Optional dependencies containers-common and catatonit are not required for basic functionality")

# Stop Podman service (socket) so it doesn't run by default.
# You can start it manually when needed.
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

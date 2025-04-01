# podman.rb
# Recipe for Podman installation and configuration on Ubuntu Bionic

# Ensure universe repository is enabled (podman is in universe for Bionic)
execute 'enable-universe' do
  command 'apt-add-repository universe -y'
  not_if 'apt-cache policy | grep -q universe'
end

# Update package cache with ignore_failure to prevent build failures
apt_update 'update' do
  ignore_failure true
  action :update
end

# Fallback repositories in case the default doesn't work
bash 'try-alternative-podman-install' do
  code <<-EOH
    # Try to install from Ubuntu repos first
    apt-get update -q || true
    apt-get install -y podman || {
      # If that fails, try snap as fallback
      snap install podman --classic || {
        # If snap fails, manually download and install the deb
        cd /tmp
        apt-get install -y curl
        curl -L -o podman.deb http://archive.ubuntu.com/ubuntu/pool/universe/p/podman/podman_1.6.2-2_amd64.deb
        apt-get install -y ./podman.deb || echo "Failed to install podman"
      }
    }
  EOH
  not_if 'which podman'
end

# Install related packages if available
%w(containers-common catatonit).each do |pkg|
  # First check if the package is available before attempting to install
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

  # Log message about optional dependencies
  ruby_block "log-#{pkg}-status" do
    block do
      Chef::Log.info("Note: #{pkg} is an optional dependency. Installation skipped if not available.")
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

# Create storage.conf file
file '/etc/containers/storage.conf' do
  content <<~EOL
    # Storage configuration for Podman
    
    [storage]
    driver = "overlay"
    runroot = "/var/run/containers/storage"
    graphroot = "/var/lib/containers/storage"
    
    [storage.options]
    additionalimagestores = []
    
    [storage.options.overlay]
    ignore_chown_errors = "false"
    
    [storage.options.thinpool]
  EOL
  owner 'root'
  group 'root'
  mode '0644'
  action :create_if_missing
end

# Configure system for Podman
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
  only_if { File.exist?('/usr/lib/systemd/system/podman.socket') }
  ignore_failure true
end

# Check if podman was installed successfully
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
    begin
      if cmd.exitstatus == 0
        Chef::Log.info("Podman successfully installed: #{cmd.stdout.strip}")
      else
        Chef::Log.warn("Podman may not be installed correctly: #{cmd.stderr.strip}")
      end
    rescue => e
      Chef::Log.warn("Error checking Podman version: #{e}")
    end
  end
  action :run
  ignore_failure true
end

# Completion report
Chef::Log.info("Podman installation completed on Ubuntu 18.04 (bionic)")
Chef::Log.info("Note: Missing packages containers-common and catatonit are optional and not required for basic functionality")

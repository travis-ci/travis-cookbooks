# podman.rb
# Recipe for Podman installation and configuration on Ubuntu Bionic

# Add Kubic repository for Podman
apt_repository 'devel_kubic_libcontainers_stable' do
  uri 'https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_18.04/'
  key 'https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_18.04/Release.key'
  components ['main']
  action :add
end

# Update package cache
apt_update 'update' do
  action :update
end

# Install Podman and related packages
%w(podman containers-common catatonit).each do |pkg|
  package pkg do
    action :install
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
end

# Completion report
Chef::Log.info("Podman installation completed successfully on Ubuntu 18.04 (bionic)")

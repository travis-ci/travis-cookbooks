require 'digest'

# Install unzip package (required for ark to extract the archive)
package 'unzip' do
  action :install
end

# Set up paths
setup_root  = node['android-sdk']['setup_root'].to_s.empty? ? node['ark']['prefix_home'] : node['android-sdk']['setup_root']
android_name = node['android-sdk']['name']
android_home = File.join(setup_root, android_name)
android_bin  = File.join(android_home, 'cmdline-tools', 'latest', 'bin', 'sdkmanager')
temp_file    = "/tmp/android-sdk.zip"
android_sdk_url = node['android-sdk']['download_url']

# Download the Android SDK archive
remote_file temp_file do
  source android_sdk_url
  action :create
  not_if { ::File.exist?(temp_file) }
end

# Calculate SHA256 checksum
ruby_block "calculate_checksum" do
  block do
    if ::File.exist?(temp_file)
      checksum = Digest::SHA256.file(temp_file).hexdigest
      node.run_state['android_sdk_checksum'] = checksum
      Chef::Log.info("Dynamic checksum: #{checksum}")
    else
      Chef::Log.error("File #{temp_file} does not exist! Cannot calculate checksum.")
    end
  end
  action :run
  only_if { ::File.exist?(temp_file) }
end

# Remove existing installation directory if it exists
if ::Dir.exist?(android_home)
  directory android_home do
    recursive true
    action :delete
  end
end

# Create the setup root directory
directory setup_root do
  owner node['android-sdk']['owner']
  group node['android-sdk']['group']
  mode '0755'
  recursive true
  action :create
end

# Install Android SDK using ark without creating a symlink
ark android_name do
  url android_sdk_url
  path setup_root
  checksum lazy { node.run_state['android_sdk_checksum'] }
  version node['android-sdk']['version']
  prefix_root setup_root
  prefix_home setup_root
  owner node['android-sdk']['owner']
  group node['android-sdk']['group']
  strip_components 0
  action :put  # Do not create a symlink
end

# Grant read and execute permissions to the SDK files
execute 'Grant read and execute permissions' do
  command "chmod -R a+rX #{android_home}/*"
  user node['android-sdk']['owner']
  group node['android-sdk']['group']
  action :run
end

# Install SDK components - create an execute resource for each component
node['android-sdk']['components'].each do |sdk_component|
  execute "Install Android SDK component #{sdk_component}" do
    command "#{android_bin} --install #{sdk_component} --sdk_root=#{android_home}"
    user node['android-sdk']['owner']
    group node['android-sdk']['group']
    only_if { ::File.exist?(android_bin) }
    action :run
  end
end

# Log error if sdkmanager is not found
ruby_block "log_sdk_manager_not_found" do
  block do
    Chef::Log.error("Android SDK Manager not found: #{android_bin}")
  end
  not_if { ::File.exist?(android_bin) }
  action :run
end

# Copy additional scripts
scripts_path = node['android-sdk']['scripts']['path']

directory scripts_path do
  owner node['android-sdk']['scripts']['owner']
  group node['android-sdk']['scripts']['group']
  mode '0755'
  recursive true
  action :create
end

%w(android-accept-licenses android-wait-for-emulator).each do |script|
  cookbook_file File.join(scripts_path, script) do
    source script
    owner node['android-sdk']['scripts']['owner']
    group node['android-sdk']['scripts']['group']
    mode '0755'
    action :create
  end
end

%w(android-update-sdk).each do |script|
  template File.join(scripts_path, script) do
    source "#{script}.erb"
    owner node['android-sdk']['scripts']['owner']
    group node['android-sdk']['scripts']['group']
    mode '0755'
    action :create
  end
end

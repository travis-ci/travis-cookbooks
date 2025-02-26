require 'digest'

package 'unzip' do
  action :install
end

setup_root = node['android-sdk']['setup_root'].to_s.empty? ? node['ark']['prefix_home'] : node['android-sdk']['setup_root']
android_name = node['android-sdk']['name']
android_home = File.join(setup_root, android_name)
cmdline_tools_path = File.join(android_home, 'cmdline-tools', 'latest')
sdkmanager_bin = File.join(cmdline_tools_path, 'cmdline-tools', 'bin', 'sdkmanager')
temp_file = "/tmp/android-sdk.zip"
android_sdk_url = node['android-sdk']['download_url']
license_file_path = node['android-sdk']['license_file_path']
android_accept_licenses_path = node['android-sdk']['license_file_path']

remote_file temp_file do
  source android_sdk_url
  action :create
  not_if { ::File.exist?(temp_file) }
end

ruby_block "calculate_checksum" do
  block do
    if ::File.exist?(temp_file)
      checksum = Digest::SHA256.file(temp_file).hexdigest
      node.run_state['android_sdk_checksum'] = checksum
      Chef::Log.info("✅ Dynamic checksum: #{checksum}")
    else
      Chef::Log.error("❌ File #{temp_file} does not exist! Cannot compute checksum.")
    end
  end
  action :run
  only_if { ::File.exist?(temp_file) }
end

[setup_root, android_home, cmdline_tools_path].each do |dir_path|
  directory dir_path do
    owner node['android-sdk']['owner']
    group node['android-sdk']['group']
    mode '0755'
    recursive true
    action :create
  end
end

execute "Unpack Android SDK" do
  command "unzip -q #{temp_file} -d #{cmdline_tools_path} && mv #{cmdline_tools_path}/cmdline-tools #{cmdline_tools_path}/latest"
  not_if { ::File.exist?(sdkmanager_bin) }
  action :run
end

execute 'Grant read and execute permissions' do
  command "chmod -R a+rX #{android_home}/*"
  user node['android-sdk']['owner']
  group node['android-sdk']['group']
  action :run
end

node['android-sdk']['components'].each do |sdk_component|
  execute "Install Android SDK component #{sdk_component}" do
    command "#{sdkmanager_bin} --install #{sdk_component} --sdk_root=#{android_home}"
    user node['android-sdk']['owner']
    group node['android-sdk']['group']
    only_if { ::File.exist?(sdkmanager_bin) }
    action :run
  end
end

ruby_block "log_sdk_manager_not_found" do
  block do
    Chef::Log.error("❌ Android SDK Manager not found: #{sdkmanager_bin}")
  end
  not_if { ::File.exist?(sdkmanager_bin) }
  action :run
end

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

# Ensure license file exists
# ruby_block "check_license_file" do
#   block do
#     unless ::File.exist?(license_file_path)
#       Chef::Log.error("❌ License file not found at: #{license_file_path}")
#       raise "Android SDK License file missing!"
#     else
#       Chef::Log.info("✅ License file found: #{license_file_path}")
#     end
#   end
#   action :run
# end

# # Ensure android-accept-licenses file exists and is executable
# ruby_block "check_android_accept_licenses" do
#   block do
#     unless ::File.exist?(android_accept_licenses_path)
#       Chef::Log.error("❌ Android accept licenses file not found at: #{android_accept_licenses_path}")
#       raise "Android accept licenses file missing!"
#     else
#       Chef::Log.info("✅ Android accept licenses file found: #{android_accept_licenses_path}")
#     end
#   end
#   action :run
# end

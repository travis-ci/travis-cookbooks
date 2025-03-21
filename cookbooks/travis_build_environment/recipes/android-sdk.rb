require 'digest'

package 'unzip' do
  action :install
end

setup_root = node['android-sdk']['setup_root'].to_s.empty? ? node['ark']['prefix_home'] : node['android-sdk']['setup_root']
android_name = node['android-sdk']['name']
android_home = File.join(setup_root, android_name)
cmdline_tools_dir = File.join(android_home, 'cmdline-tools')
cmdline_tools_bin = File.join(cmdline_tools_dir, 'bin')
sdkmanager_bin = File.join(cmdline_tools_bin, 'sdkmanager')

temp_file = File.join(Chef::Config[:file_cache_path], "android-sdk.zip")
android_sdk_url = node['android-sdk']['download_url']

remote_file temp_file do
  source android_sdk_url
  mode '0644'
  backup false
  action :create_if_missing
  notifies :run, 'ruby_block[calculate_checksum]', :immediately
end

ruby_block "calculate_checksum" do
  block do
    if ::File.exist?(temp_file)
      checksum = Digest::MD5.file(temp_file).hexdigest
      node.run_state['android_sdk_checksum'] = checksum
      Chef::Log.info("✅ Calculated checksum: #{checksum}")
    else
      Chef::Log.error("❌ File #{temp_file} does not exist! Cannot calculate checksum.")
      raise "Android SDK installation file does not exist: #{temp_file}"
    end
  end
  action :nothing
end

ruby_block "verify_checksum" do
  block do
    expected_checksum = node['android-sdk']['checksum']
    computed_checksum = node.run_state['android_sdk_checksum']
    if computed_checksum != expected_checksum
      Chef::Log.error("❌ Checksum mismatch: expected #{expected_checksum}, got #{computed_checksum}")
      raise "Checksum verification failed for #{temp_file}"
    else
      Chef::Log.info("✅ Checksum verification passed.")
    end
  end
  action :run
  only_if { ::File.exist?(temp_file) && node.run_state['android_sdk_checksum'] }
  subscribes :run, 'ruby_block[calculate_checksum]', :immediately
end

[setup_root, android_home, cmdline_tools_dir, cmdline_tools_dir].each do |dir_path|
  directory dir_path do
    owner node['android-sdk']['owner']
    group node['android-sdk']['group']
    mode '0755'
    recursive true
    action :create
  end
end

execute "Extract Android SDK" do
  command "unzip -q #{temp_file} -d #{android_home}"
  user node['android-sdk']['owner']
  group node['android-sdk']['group']
  not_if { ::File.exist?(sdkmanager_bin) }
  notifies :run, 'ruby_block[verify_extraction]', :immediately
end

ruby_block "verify_extraction" do
  block do
    if ::File.exist?(sdkmanager_bin)
      Chef::Log.info("✅ Android SDK successfully extracted at: #{sdkmanager_bin}")
    else
      Chef::Log.error("❌ Android SDK Manager not found after extraction: #{sdkmanager_bin}")
      raise "Android SDK extraction failed"
    end
  end
  action :nothing
end

execute 'Grant read and execute permissions' do
  command "chmod -R a+rX #{android_home}"
  user node['android-sdk']['owner']
  group node['android-sdk']['group']
  action :run
end

directory android_home do
  owner node['android-sdk']['owner']
  group node['android-sdk']['group']
  mode '0777'
  recursive true
  action :create
end

node['android-sdk']['components'].each do |sdk_component|
  execute "Install Android SDK component: #{sdk_component}" do
    command "#{sdkmanager_bin} --install \"#{sdk_component}\" --sdk_root=#{android_home}"
    user node['android-sdk']['owner']
    group node['android-sdk']['group']
    environment({ 'JAVA_HOME' => node['android-sdk']['java_home'] }) if node['android-sdk']['java_home']
    only_if { ::File.exist?(sdkmanager_bin) }
    action :run
  end
end

ruby_block "log_sdk_manager_not_found" do
  block do
    Chef::Log.error("❌ Android SDK Manager not found: #{sdkmanager_bin}")
    raise "Android SDK Manager does not exist, installation failed"
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

license_file_path = node['android-sdk']['license_file_path']
if node['android-sdk']['verify_license'] == true
  ruby_block "check_license_file" do
    block do
      if ::File.exist?(license_file_path)
        Chef::Log.info("✅ License file found: #{license_file_path}")
      else
        Chef::Log.error("❌ License file not found: #{license_file_path}")
        raise "Android SDK License file missing!"
      end
    end
    action :run
  end

  android_accept_licenses_path = File.join(scripts_path, 'android-accept-licenses')
  ruby_block "check_android_accept_licenses" do
    block do
      if ::File.exist?(android_accept_licenses_path)
        Chef::Log.info("✅ Android accept licenses file found: #{android_accept_licenses_path}")
      else
        Chef::Log.error("❌ Android accept licenses file not found: #{android_accept_licenses_path}")
        raise "Android accept licenses file missing!"
      end
    end
    action :run
  end
end

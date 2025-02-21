require 'digest'

# Ustawienia ścieżek
setup_root       = node['android-sdk']['setup_root'].to_s.empty? ? node['ark']['prefix_home'] : node['android-sdk']['setup_root']
android_home     = File.join(setup_root, node['android-sdk']['name'])
android_bin      = File.join(android_home, 'cmdline-tools', 'latest', 'bin', 'sdkmanager')
temp_file        = "/tmp/android-sdk.zip"
android_sdk_url  = node['android-sdk']['download_url']

# Pobranie pliku Android SDK przed jego instalacją
remote_file temp_file do
  source android_sdk_url
  action :create
end

# Obliczenie sumy kontrolnej SHA256
directory "#{setup_root}" do
  owner node['android-sdk']['owner']
  group node['android-sdk']['group']
  mode '755'
  recursive true
  action :create
end

ruby_block "calculate_checksum" do
  block do
    if File.exist?(temp_file)
      checksum = Digest::SHA256.file(temp_file).hexdigest
      node.run_state['android_sdk_checksum'] = checksum
      Chef::Log.info("✅ Dynamic checksum: #{checksum}")
    else
      Chef::Log.error("❌ Plik #{temp_file} nie istnieje! Nie można obliczyć sumy kontrolnej.")
    end
  end
  action :run
  only_if { ::File.exist?(temp_file) }
end

# Instalacja pakietów zależnych
if platform?('ubuntu')
  package 'libgl1-mesa-dev'
  if node['kernel']['machine'] != 'i686'
    package 'lib32stdc++6' if node['platform_version'].to_f >= 13.04
    package 'libstdc++6:i386' if node['platform_version'].to_f >= 11.10
    package 'lib32z1'
  end
end

# Pobranie i instalacja Android SDK
directory android_home do
  owner node['android-sdk']['owner']
  group node['android-sdk']['group']
  mode '755'
  action :create
end

ark node['android-sdk']['name'] do
  url android_sdk_url
  path node['android-sdk']['setup_root']
  checksum lazy { node.run_state['android_sdk_checksum'] }
  version node['android-sdk']['version']
  prefix_root node['android-sdk']['setup_root']
  prefix_home node['android-sdk']['setup_root']
  owner node['android-sdk']['owner']
  group node['android-sdk']['group']
  strip_components 0
  action node['android-sdk']['with_symlink'] ? :install : :put
end

# Nadanie uprawnień
execute 'Grant all users to read android files' do
  command "chmod -R a+r #{android_home}/*"
  user node['android-sdk']['owner']
  group node['android-sdk']['group']
end

execute 'Grant all users to execute android tools' do
  command "chmod -R a+X #{File.join(android_home, 'cmdline-tools', 'latest', 'bin')}/*"
  user node['android-sdk']['owner']
  group node['android-sdk']['group']
end

# Instalacja składników SDK
if File.exist?(android_bin)
  node['android-sdk']['components'].each do |sdk_component|
    execute "Install Android SDK component #{sdk_component}" do
      command "#{android_bin} --install #{sdk_component} --sdk_root=#{android_home}"
      user node['android-sdk']['owner']
      group node['android-sdk']['group']
    end
  end
else
  Chef::Log.error("❌ Android SDK Manager nie został znaleziony: #{android_bin}")
end

# Kopiowanie dodatkowych skryptów
directory node['android-sdk']['scripts']['path'] do
  owner node['android-sdk']['scripts']['owner']
  group node['android-sdk']['scripts']['group']
  mode '755'
  recursive true
  action :create
end

%w(android-accept-licenses android-wait-for-emulator).each do |android_helper_script|
  cookbook_file File.join(node['android-sdk']['scripts']['path'], android_helper_script) do
    source android_helper_script
    owner node['android-sdk']['scripts']['owner']
    group node['android-sdk']['scripts']['group']
    mode '755'
  end
end

%w(android-update-sdk).each do |android_helper_script|
  template File.join(node['android-sdk']['scripts']['path'], android_helper_script) do
    source "#{android_helper_script}.erb"
    owner node['android-sdk']['scripts']['owner']
    group node['android-sdk']['scripts']['group']
    mode '755'
  end
end

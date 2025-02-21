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

# Tworzenie katalogu instalacyjnego
if File.directory?(android_home)
  directory android_home do
    recursive true
    action :delete
  end
end

directory setup_root do
  owner node['android-sdk']['owner']
  group node['android-sdk']['group']
  mode '755'
  recursive true
  action :create
end

directory android_home do
  owner node['android-sdk']['owner']
  group node['android-sdk']['group']
  mode '755'
  action :create
end

# Instalacja Android SDK
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
execute 'Grant all users read access to android files' do
  command "chmod -R a+r #{android_home}/*"
  user node['android-sdk']['owner']
  group node['android-sdk']['group']
end

execute 'Grant all users execute permission for android tools' do
  command "chmod -R a+X #{File.join(android_home, 'cmdline-tools', 'latest', 'bin')}/*"
  user node['android-sdk']['owner']
  group node['android-sdk']['group']
end

# Instalacja składników SDK
ruby_block "install_sdk_components" do
  block do
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
  end
  action :run
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

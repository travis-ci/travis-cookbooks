require 'digest'

# Ustawienia ścieżek
setup_root = node['android-sdk']['setup_root'].to_s.empty? ? node['ark']['prefix_home'] : node['android-sdk']['setup_root']
android_home = File.join(setup_root, node['android-sdk']['name'])
android_bin = File.join(android_home, 'cmdline-tools', 'latest', 'bin', 'sdkmanager')
temp_file = "/tmp/android-sdk.zip"
android_sdk_url = node['android-sdk']['download_url']

# Pobranie pliku Android SDK
remote_file temp_file do
  source android_sdk_url
  action :create
  not_if { ::File.exist?(temp_file) }
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

# Sprawdzenie i usunięcie istniejącego katalogu
if Dir.exist?(android_home)
  directory android_home do
    recursive true
    action :delete
  end
end

# Tworzenie wymaganych katalogów
[setup_root, android_home].each do |dir|
  directory dir do
    owner node['android-sdk']['owner']
    group node['android-sdk']['group']
    mode '755'
    recursive true
    action :create
  end
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

# Nadanie uprawnień do plików
execute 'Grant read and execute permissions' do
  command "chmod -R a+rX #{android_home}/*"
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
scripts_path = node['android-sdk']['scripts']['path']

directory scripts_path do
  owner node['android-sdk']['scripts']['owner']
  group node['android-sdk']['scripts']['group']
  mode '755'
  recursive true
  action :create
end

%w(android-accept-licenses android-wait-for-emulator).each do |script|
  cookbook_file File.join(scripts_path, script) do
    source script
    owner node['android-sdk']['scripts']['owner']
    group node['android-sdk']['scripts']['group']
    mode '755'
  end
end

%w(android-update-sdk).each do |script|
  template File.join(scripts_path, script) do
    source "#{script}.erb"
    owner node['android-sdk']['scripts']['owner']
    group node['android-sdk']['scripts']['group']
    mode '755'
  end
end

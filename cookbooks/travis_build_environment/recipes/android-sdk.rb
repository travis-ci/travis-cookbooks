# frozen_string_literal: true

# Definicja zmiennych atrybutów
android_sdk = node['android-sdk']
sdk_root = android_sdk['setup_root']
sdk_version = android_sdk['version']
license_file = android_sdk['license_file_path']

# Tworzenie katalogu dla Android SDK
directory sdk_root do
  owner android_sdk['owner']
  group android_sdk['group']
  mode '0755'
  action :create
  recursive true
end

# Pobieranie pakietu Android SDK CLI tools
remote_file "#{Chef::Config[:file_cache_path]}/commandlinetools-linux-#{sdk_version}_latest.zip" do
  source android_sdk['download_url']
  checksum android_sdk['checksum']
  owner android_sdk['owner']
  group android_sdk['group']
  mode '0644'
  action :create
end

# Rozpakowanie pakietu do katalogu Android SDK
execute 'extract_android_sdk' do
  command "unzip -o #{Chef::Config[:file_cache_path]}/commandlinetools-linux-#{sdk_version}_latest.zip -d #{sdk_root}"
  user android_sdk['owner']
  group android_sdk['group']
  not_if { ::File.exist?("#{sdk_root}/cmdline-tools") }
end

# Konfiguracja pliku akceptującego licencje Android SDK
cookbook_file '/usr/local/bin/android-accept-licenses' do
  source license_file
  owner android_sdk['owner']
  group android_sdk['group']
  mode '0755'
  action :create
end

# Ustawienie zmiennych środowiskowych dla Android SDK
if android_sdk['set_environment_variables']
  file '/etc/profile.d/android-sdk.sh' do
    content <<-EOF
      export ANDROID_HOME=#{sdk_root}
      export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH
    EOF
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end
end

# Instalacja wymaganych komponentów SDK
android_sdk['components'].each do |component|
  execute "install_#{component}" do
    command "#{sdk_root}/cmdline-tools/latest/bin/sdkmanager --install '#{component}' --sdk_root=#{sdk_root}"
    user android_sdk['owner']
    group android_sdk['group']
    environment(
      'ANDROID_HOME' => sdk_root,
      'PATH' => "#{sdk_root}/cmdline-tools/latest/bin:#{sdk_root}/platform-tools:#{ENV['PATH']}"
    )
    not_if { ::Dir.exist?("#{sdk_root}/#{component}") }
  end
end

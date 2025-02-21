# recipes/android-sdk.rb

require 'digest'

setup_root       = node['android-sdk']['setup_root'].to_s.empty? ? node['ark']['prefix_home'] : node['android-sdk']['setup_root']
android_home     = File.join(setup_root, node['android-sdk']['name'])
android_bin      = File.join(android_home, 'tools', 'android')
temp_file        = "/tmp/android-sdk.zip"
android_sdk_url  = node['android-sdk']['download_url']

remote_file temp_file do
  source android_sdk_url
  action :create
end

ruby_block "calculate_checksum" do
  block do
    checksum = Digest::SHA256.file(temp_file).hexdigest
    node.override['android-sdk']['checksum'] = checksum
    Chef::Log.info("✅ Dynamic checksum: #{checksum}")
  end
  action :run
end

if node['platform'] == 'ubuntu'
  package 'libgl1-mesa-dev'
  if node['kernel']['machine'] != 'i686'
    if Chef::VersionConstraint.new('>= 13.04').include?(node['platform_version'])
      package 'lib32stdc++6'
    elsif Chef::VersionConstraint.new('>= 11.10').include?(node['platform_version'])
      package 'libstdc++6:i386'
    end
    package 'lib32z1'
  end
end

ark node['android-sdk']['name'] do
  url android_sdk_url
  path node['android-sdk']['setup_root']
  checksum lazy { node['android-sdk']['checksum'] } 
  version node['android-sdk']['version']
  prefix_root node['android-sdk']['setup_root']
  prefix_home node['android-sdk']['setup_root']
  owner node['android-sdk']['owner']
  group node['android-sdk']['group']
  strip_components 0
  action node['android-sdk']['with_symlink'] ? :install : :put
end


directory File.join(android_home, 'tools') do
  mode '755'
  user node['android-sdk']['owner']
  group node['android-sdk']['group']
end

execute 'Grant all users to read android files' do
  command "chmod -R a+r #{android_home}/*"
  user node['android-sdk']['owner']
  group node['android-sdk']['group']
end

execute 'Grant all users to execute android tools' do
  command "chmod -R a+X #{File.join(android_home, 'tools')}/*"
  user node['android-sdk']['owner']
  group node['android-sdk']['group']
end


template "/etc/profile.d/#{node['android-sdk']['name']}.sh" do
  source 'android-sdk.sh.erb'
  mode '644'
  owner node['android-sdk']['owner']
  group node['android-sdk']['group']
  variables(
    android_home: android_home
  )
  only_if { node['android-sdk']['set_environment_variables'] }
end

package 'expect'

unless File.exist?("#{setup_root}/#{node['android-sdk']['name']}/temp")
  node['android-sdk']['components'].each do |sdk_component|
    script "Install Android SDK component #{sdk_component}" do
      interpreter 'expect'
      environment 'ANDROID_HOME' => android_home
      user node['android-sdk']['owner']
      group node['android-sdk']['group']
      code <<-EOF
        spawn #{android_bin} update sdk --no-ui --all --filter #{sdk_component}
        set timeout 1800
        expect {
          -regexp "Do you accept the license '(#{node['android-sdk']['license']['white_list'].join('|')})'.*" {
                exp_send "y\r"
                exp_continue
          }
          -regexp "Do you accept the license '(#{node['android-sdk']['license']['black_list'].join('|')})'.*" {
                exp_send "n\r"
                exp_continue
          }
          "Do you accept the license '*-license-*'*" {
                exp_send "#{node['android-sdk']['license']['default_answer']}\r"
                exp_continue
          }
          eof
        }
      EOF
    end
  end
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

#
#
#include_recipe 'android-sdk::maven_rescue' if node['android-sdk']['maven_rescue']

package 'unzip'

default_jvm = nil

unless node['travis_java']['default_version'] == ''
  include_recipe "travis_java::#{node['travis_java']['default_version']}"
  default_jvm = node['travis_java'][node['travis_java']['default_version']]['jvm_name']
end

template(File.join(node['travis_build_environment']['home'], '.jdk_switcher_rc')) do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o644
  source 'jdk_switcher.sh.erb'
end

cookbook_file '/etc/profile.d/load_jdk_switcher.sh' do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o755
end

unless Array(node['travis_java']['alternate_versions']).empty?
  include_recipe 'travis_java::multi'
end

execute "Set #{default_jvm} as default alternative" do
  command "update-java-alternatives -s #{default_jvm}"
  not_if { default_jvm.nil? }
end

template '/etc/profile.d/java_home.sh' do
  source 'etc/profile.d/java_home.sh.erb'
  owner 'root'
  group 'root'
  mode 0o644
  not_if { default_jvm.nil? }
end

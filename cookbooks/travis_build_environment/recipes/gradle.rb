include_recipe 'travis_groovy'

ark 'gradle' do
  url node['travis_build_environment']['gradle_url']
  version node['travis_build_environment']['gradle_version']
  checksum node['travis_build_environment']['gradle_checksum']
  has_binaries %w[bin/gradle]
  owner 'root'
  group 'root'
end

directory "#{node['travis_build_environment']['home']}/.gradle" do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode '0755'
  action :create
end

file "gradle.properties" do
  path "#{node['travis_build_environment']['home']}/.gradle/gradle.properties"
  content 'org.gradle.daemon=false'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode '0644'
  action :create
end

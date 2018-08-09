include_recipe 'travis_groovy'

ark 'gradle' do
  url node['travis_build_environment']['gradle_url']
  version node['travis_build_environment']['gradle_version']
  checksum node['travis_build_environment']['gradle_checksum']
  has_binaries %w[bin/gradle]
  owner 'root'
  group 'root'
end

file "#{node['travis_build_environment']['user']}/.gradle/gradle.properties" do
  content 'org.gradle.daemon=false'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode '0644'
  action :create
end

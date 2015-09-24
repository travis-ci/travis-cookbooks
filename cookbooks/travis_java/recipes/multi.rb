# On Ubuntu 12.04, there are some package conflicts between 'tzdata',
# 'tzdata-java' and opendjdk packages.  Workaround consists in forcing
# re-installation of "compatible" versions of tzdata and tzdata-java...  See
# also 'java::openjdk6' recipe and 'travis_timezone' cookbook.
include_recipe 'travis_timezone'

node['travis_java']['alternate_versions'].each do |java_version|
  Chef::Log.info("Installing Java #{java_version}.")
  include_recipe "java::#{java_version}"
end

# provision jdk_switcher
template(File.join(node['travis_build_environment']['home'], '.jdk_switcher_rc')) do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0644

  source 'jdk_switcher.sh.erb'
end

cookbook_file '/etc/profile.d/load_jdk_switcher.sh' do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0755
end

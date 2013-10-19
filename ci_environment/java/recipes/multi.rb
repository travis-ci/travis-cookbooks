#
# On Ubuntu 12.04, there are some package conflicts between 'tzdata', 'tzdata-java' and opendjdk packages.
# Workaround consists in forcing re-installation of "compatible" versions of tzdata and tzdata-java...
# See also 'java::openjdk6' recipe and 'timezone' cookbook.
#
include_recipe "timezone"
case node['platform']
when "ubuntu", "debian"
  bash "autoremove and autoclean packages" do
    user "root"
    code "apt-get -y autoclean autoremove && apt-get -f install"
  end
end

node['java']['alternate_versions'].each do |java_version|
  Chef::Log.info("Installing Java #{java_version}.")
  include_recipe "java::#{java_version}"
end

# provision jdk_switcher
template(File.join(node['travis_build_environment']['home'], ".jdk_switcher_rc")) do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0644

  source "jdk_switcher.sh.erb"
end

cookbook_file "/etc/profile.d/load_jdk_switcher.sh" do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0755
end

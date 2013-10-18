include_recipe "timezone"

case node.platform
when "ubuntu", "debian"
  bash "autoremove and autoclean packages" do
    user "root"
    code "apt-get -y autoclean autoremove && apt-get -f install"
  end  
end

node.java.multi.versions.each do |java_version|
  Chef::Log.info("Installing Java #{java_version}.")
  include_recipe "java::#{java_version}"
end

#
# Assumed that all installed JDKs are correctly registered as 'alternatives',
# we still have to switch to the default that corresponds to jdk_switcher.
# TODO: this will be improved later with attribute refactoring and jdk_switcher templating
#
java_default_version = 'java-7-oracle'
execute "Set #{java_default_version} as default alternative" do
  command "update-java-alternatives -s #{java_default_version}"
end

# provision jdk_switcher
remote_file(File.join(node.travis_build_environment.home, ".jdk_switcher_rc")) do
  owner node.travis_build_environment.user
  group node.travis_build_environment.group

  mode 0644

  source "https://raw.github.com/michaelklishin/jdk_switcher/master/jdk_switcher.sh"
end

cookbook_file "/etc/profile.d/load_jdk_switcher.sh" do
  owner node.travis_build_environment.user
  group node.travis_build_environment.group
  mode 0755
end

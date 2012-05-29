node['java']['multi']['versions'].each do |java_version|
  Chef::Log.info("Installing Java #{java_version}.")
  include_recipe "java::#{java_version}"
end

# provision jdk_switcher
remote_file(File.join(node.travis_build_environment.home, ".jdk_switcher_rc")) do
  owner node.travis_build_environment.user
  group node.travis_build_environment.group

  mode 0644

  source "https://raw.github.com/michaelklishin/jdk_switcher/master/jdk_switcher.sh"
end

# install a shell script that will set JAVA_HOME to the default JDK on boot
# cookbook_file "/etc/profile.d/export_java_home.sh" do
#   owner node.travis_build_environment.user
#   group node.travis_build_environment.group
#   mode 0755
# end

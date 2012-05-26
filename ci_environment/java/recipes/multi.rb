node['java']['multi']['versions'].each do |java_version|
  Chef::Log.info("Installing Java #{java_version}.")
  include_recipe "java::#{java_version}"
end

remote_file(node.java.multi.switcher_path) do
  owner node.travis_build_environment.user
  group node.travis_build_environment.group

  mode 0755

  source "https://raw.github.com/michaelklishin/jdk_switcher/master/jdk_switcher.sh"
end

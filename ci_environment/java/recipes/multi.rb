node['java']['multi']['versions'].each do |java_version|
  Chef::Log.info("Installing Java #{java_version}.")
  include_recipe "java::#{java_version}"
end

default['java']['arch'] = 'i386'
if kernel['machine'] =~ /x86_64/
  default['java']['arch'] = 'amd64'
end
default['java']['jvm_base_dir'] = '/usr/lib/jvm'
default['java']['default_version'] = 'oraclejdk7'
default['java']['alternate_versions'] = []
default['java']['openjdk6']['jvm_name'] = "java-1.6.0-openjdk-#{node['java']['arch']}"
default['java']['openjdk7']['jvm_name'] = "java-1.7.0-openjdk-#{node['java']['arch']}"
default['java']['oraclejdk7']['jvm_name'] = 'java-7-oracle'
default['java']['oraclejdk7']['install_jce_unlimited'] = true
default['java']['oraclejdk7']['pinned_release'] = nil
default['java']['oraclejdk8']['jvm_name'] = 'java-8-oracle'
default['java']['oraclejdk8']['install_jce_unlimited'] = true
default['java']['oraclejdk8']['pinned_release'] = nil

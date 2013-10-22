
arch = kernel['machine'] =~ /x86_64/ ? "amd64" : "i386"
default['java']['arch'] = arch

default['java']['jvm_base_dir']  = '/usr/lib/jvm'

default['java']['default_version']     = 'oraclejdk7'
default['java']['alternate_versions']  = []            # to be overidden for JVM or Ruby VMs, e.g. with: %w(openjdk6 openjdk7 oraclejdk8)


default['java']['openjdk6']['jvm_name']                = "java-1.6.0-openjdk-#{node['java']['arch']}"

default['java']['openjdk7']['jvm_name']                = "java-1.7.0-openjdk-#{node['java']['arch']}"

default['java']['oraclejdk7']['jvm_name']              = 'java-7-oracle'
default['java']['oraclejdk7']['install_jce_unlimited'] = true

default['java']['oraclejdk8']['jvm_name']              = 'java-8-oracle'

#
# Still have to set the default JAVA_HOME as 'java.java_home' attribute,
# since other cookbooks externally refer to this value (e.g. travis_build_environment)
#
default['java']['java_home'] = File.join(node['java']['jvm_base_dir'], node['java'][node['java']['default_version']]['jvm_name'])

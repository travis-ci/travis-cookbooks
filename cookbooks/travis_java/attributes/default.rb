default['travis_java']['arch'] = 'i386'
default['travis_java']['arch'] = 'amd64' if kernel['machine'] =~ /x86_64/
default['travis_java']['jvm_base_dir'] = '/usr/lib/jvm'
default['travis_java']['default_version'] = 'oraclejdk7'
default['travis_java']['alternate_versions'] = []
default['travis_java']['openjdk6']['jvm_name'] = "java-1.6.0-openjdk-#{node['travis_java']['arch']}"
default['travis_java']['openjdk7']['jvm_name'] = "java-1.7.0-openjdk-#{node['travis_java']['arch']}"
default['travis_java']['openjdk8']['jvm_name'] = "java-1.8.0-openjdk-#{node['travis_java']['arch']}"
default['travis_java']['oraclejdk7']['jvm_name'] = 'java-7-oracle'
default['travis_java']['oraclejdk7']['install_jce_unlimited'] = true
default['travis_java']['oraclejdk7']['pinned_release'] = nil
default['travis_java']['oraclejdk8']['jvm_name'] = 'java-8-oracle'
default['travis_java']['oraclejdk8']['install_jce_unlimited'] = true
default['travis_java']['oraclejdk8']['pinned_release'] = nil

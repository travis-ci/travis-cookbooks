include_attribute 'travis_build_environment'

default['travis_java']['arch'] = 'i386'
default['travis_java']['arch'] = 'amd64' if node['kernel']['machine'] =~ /x86_64/
default['travis_java']['arch'] = 'ppc64el' if node['kernel']['machine'] =~ /ppc64le/

default['travis_java']['alternate_versions'] = []
default['travis_java']['default_version'] = 'oraclejdk8'
if node['kernel']['machine'] == 'ppc64le'
  default['travis_java']['default_version'] = 'openjdk8'
end

default['travis_java']['jdk_switcher_url'] = 'https://raw.githubusercontent.com/michaelklishin/jdk_switcher/565b95b8946abf8ce3f2b0cc87fb8260a3d5aa3c/jdk_switcher.sh'
default['travis_java']['jdk_switcher_path'] = '/opt/jdk_switcher/jdk_switcher.sh'
default['travis_java']['jvm_base_dir'] = '/usr/lib/jvm'

default['travis_java']['openjdk6']['jvm_name'] = "java-1.6.0-openjdk-#{node['travis_java']['arch']}"
default['travis_java']['openjdk7']['jvm_name'] = "java-1.7.0-openjdk-#{node['travis_java']['arch']}"
default['travis_java']['openjdk8']['jvm_name'] = "java-1.8.0-openjdk-#{node['travis_java']['arch']}"

default['travis_java']['oraclejdk7']['install_jce_unlimited'] = true
default['travis_java']['oraclejdk7']['jvm_name'] = 'java-7-oracle'
default['travis_java']['oraclejdk7']['pinned_release'] = nil
default['travis_java']['oraclejdk8']['install_jce_unlimited'] = true
default['travis_java']['oraclejdk8']['jvm_name'] = 'java-8-oracle'
default['travis_java']['oraclejdk8']['pinned_release'] = nil
default['travis_java']['oraclejdk9']['install_jce_unlimited'] = true
default['travis_java']['oraclejdk9']['jvm_name'] = 'java-9-oracle'
default['travis_java']['oraclejdk9']['pinned_release'] = nil

default['travis_java']['ibmjava']['platform'] = 'linux'
default['travis_java']['ibmjava8']['jvm_name'] = "java-8-ibm-#{node['travis_java']['arch']}"
default['travis_java']['ibmjava8']['pinned_release'] = nil
default['travis_java']['ibmjava9']['jvm_name'] = "java-9-ibm-#{node['travis_java']['arch']}"
default['travis_java']['ibmjava9']['pinned_release'] = nil

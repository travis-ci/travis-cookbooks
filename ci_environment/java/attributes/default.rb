
arch = kernel['machine'] =~ /x86_64/ ? "amd64" : "i386"
default['java']['arch'] = arch

default['java']['java_home'] = "/usr/lib/jvm/java-7-openjdk-#{arch}/"

default['java']['multi']['versions'] = %w(openjdk6 openjdk7 oraclejdk7 oraclejdk8)

default['java']['oraclejdk7']['java_home']             = "/usr/lib/jvm/java-7-oracle",
default['java']['oraclejdk7']['install_jce_unlimited'] = true

default['java']['oraclejdk8']['java_home']             = "/usr/lib/jvm/java-8-oracle"

gradle_version = '2.13'

default['gradle']['version'] = gradle_version
default['gradle']['installation_dir'] = '/usr/local/gradle'
default['gradle']['url'] = "https://downloads.gradle.org/distributions/gradle-#{gradle_version}-bin.zip"
default['gradle']['checksum'] = '0f665ec6a5a67865faf7ba0d825afb19c26705ea0597cec80dd191b0f2cbb664'

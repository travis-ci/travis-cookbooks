gradle_version = '2.7'

default['gradle']['version'] = gradle_version
default['gradle']['installation_dir'] = '/usr/local/gradle'
default['gradle']['tarball']['url'] = "https://downloads.gradle.org/distributions/gradle-#{gradle_version}-bin.zip"

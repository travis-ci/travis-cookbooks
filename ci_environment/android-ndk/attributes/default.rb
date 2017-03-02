include_attribute 'travis_build_environment'

default['android-ndk']['name']           = 'android-ndk'
default['android-ndk']['owner']          = node['travis_build_environment']['user']
default['android-ndk']['group']          = node['travis_build_environment']['group']
default['android-ndk']['setup_root']     = nil  # ark defaults (/usr/local) is used if this attribute is not defined

default['android-ndk']['version']        = 'r10'
default['android-ndk']['checksum']       = '9d0b4aab6e3f34158a3698226ab7d6c8df4aa8c9cc5242da9b733ac1f988090e'
default['android-ndk']['download_url']   = "http://dl.google.com/android/ndk/android-ndk32-#{node['android-ndk']['version']}-linux-x86_64.tar.bz2"

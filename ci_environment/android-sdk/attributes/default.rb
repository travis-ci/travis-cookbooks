include_attribute 'travis_build_environment'

default['android-sdk']['setup_dir']      = '/opt/android-sdk'
default['android-sdk']['owner']          = node['travis_build_environment']['user']
default['android-sdk']['group']          = node['travis_build_environment']['group']


default['android-sdk']['version']        = '21.0.1'
default['android-sdk']['checksum']       = 'e797ff3abbdc0fe2e7299e82e92ade830fa922ddd045d9a5a2d187c5c1a2661c'
default['android-sdk']['download_url']   = "http://dl.google.com/android/android-sdk_r#{node['android-sdk']['version']}-linux.tgz"

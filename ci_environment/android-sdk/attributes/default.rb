include_attribute 'travis_build_environment'

default['android-sdk']['name']           = 'android-sdk'

default['android-sdk']['owner']          = node['travis_build_environment']['user']
default['android-sdk']['group']          = node['travis_build_environment']['group']

# Last version without License Agreement being prompted during setup:
default['android-sdk']['version']        = '21.1'
default['android-sdk']['checksum']       = '276e3c13a10f37927d4e04d036a94a0cbbf62326981f0ba61a303b76567e3379'

# Latest version 
# TODO: have to find a 'yes' trick to automate the installation...
#default['android-sdk']['version']        = '22.0.1'
#default['android-sdk']['checksum']       = '216ae659a53682b97a0e0c2b3dc2c7c3d35011ed10302ae1a5ddbaf52a62459c'

default['android-sdk']['download_url']   = "http://dl.google.com/android/android-sdk_r#{node['android-sdk']['version']}-linux.tgz"

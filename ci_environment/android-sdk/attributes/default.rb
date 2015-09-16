include_attribute 'travis_build_environment'

default['android-sdk']['name']           = 'android-sdk'
default['android-sdk']['owner']          = node['travis_build_environment']['user']
default['android-sdk']['group']          = node['travis_build_environment']['group']
default['android-sdk']['setup_root']     = nil  # ark defaults (/usr/local) is used if this attribute is not defined

default['android-sdk']['version']        = '24.3.4'
default['android-sdk']['checksum']       = '886412375d8fe6e49a1583e57a8a36a47943666da681701ba9ad1ab7236e83ea'
default['android-sdk']['download_url']   = "http://dl.google.com/android/android-sdk_r#{node['android-sdk']['version']}-linux.tgz"

#
# List of Android SDK components to preinstall:
#
# Hint:
# Add 'tools' to the list below if you wish to get the latest version,
# without having to adapt 'version' and 'checksum' attributes of this cookbook.
# Note that it will require (waste) some extra download effort.
#
# build-tools needs to be maintained. Theoretically, there's a meta-taget
# for it.
#
default['android-sdk']['components']     = %w(platform-tools
                                              build-tools-23.0.0
                                              android-23
                                              android-22
                                              android-21
                                              sys-img-armeabi-v7a-android-21
                                              android-20
                                              android-19
                                              sys-img-armeabi-v7a-android-19
                                              android-18
                                              sys-img-armeabi-v7a-android-18
                                              android-17
                                              sys-img-armeabi-v7a-android-17
                                              android-16
                                              sys-img-armeabi-v7a-android-16
                                              android-15
                                              sys-img-armeabi-v7a-android-15
                                              android-10
                                              extra-android-support
                                              extra-google-google_play_services
                                              extra-google-m2repository
                                              extra-android-m2repository)

default['android-sdk']['license']['white_list']     = %w(.+)
default['android-sdk']['license']['black_list']     = []    # e.g. ['intel-.+', 'mips-.+', 'android-wear-sdk-license-.+']
default['android-sdk']['license']['default_answer'] = 'n'   # 'y' or 'n' ('yes' or 'no')

default['android-sdk']['scripts']['path']           = '/usr/local/bin'
default['android-sdk']['scripts']['owner']          = node['android-sdk']['owner']
default['android-sdk']['scripts']['group']          = node['android-sdk']['group']

default['android-sdk']['maven-rescue']              = false

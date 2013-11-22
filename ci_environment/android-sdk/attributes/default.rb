default['android-sdk']['name']           = 'android-sdk'
default['android-sdk']['owner']          = 'root'
default['android-sdk']['group']          = 'root'
default['android-sdk']['setup_root']     = nil  # ark defaults (/usr/local) is used if this attribute is not defined

default['android-sdk']['version']        = '22.3'
default['android-sdk']['checksum']       = '4077575c98075480e0156c10e48a1521e31c7952768271a206870e6813057f4f'

default['android-sdk']['download_url']   = "http://dl.google.com/android/android-sdk_r#{node['android-sdk']['version']}-linux.tgz"

#
# List of Android SDK components to preinstall:
# Selection based on official usage statistics (see http://developer.android.com/about/dashboards/index.html) 
#
default['android-sdk']['components']     = %w(platform-tools
                                              build-tools-19.0.0
                                              android-19
                                              sysimg-19
                                              android-18
                                              sysimg-18
                                              android-17
                                              sysimg-17
                                              android-16
                                              sysimg-16
                                              android-15
                                              sysimg-15
                                              android-14
                                              sysimg-14
                                              android-10
                                              android-8
                                              extra-android-support
                                              extra-google-google_play_services
                                              extra-google-m2repository
                                              extra-android-m2repository)

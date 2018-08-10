default['android-sdk']['name']                      = 'android-sdk'
default['android-sdk']['owner']                     = 'root'
default['android-sdk']['group']                     = 'root'
default['android-sdk']['setup_root']                = nil  # ark defaults (/usr/local) is used if this attribute is not defined
default['android-sdk']['with_symlink']              = true # use ark's :install action when true; use ark's :put action when false
default['android-sdk']['set_environment_variables'] = true

default['android-sdk']['version']                   = '26.1.1'
default['android-sdk']['checksum']                  = '92ffee5a1d98d856634e8b71132e8a95d96c83a63fde1099be3d86df3106def9'
default['android-sdk']['download_url']              = "https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip"

# Use JDK 8
default['java']['jdk_version'] = '8'

#
# List of Android SDK components to preinstall:
# Selection based on
# - Platform usage statistics (see http://developer.android.com/about/dashboards/index.html)
# - Build Tools releases: http://developer.android.com/tools/revisions/build-tools.html
#
# Hint:
# Add 'tools' to the list below if you wish to get the latest version,
# without having to adapt 'version' and 'checksum' attributes of this cookbook.
# Note that it will require (waste) some extra download effort.
#
default['android-sdk']['components']                = %w( platform-tools
                                                          emulator
                                                          build-tools;25.0.3
                                                          build-tools;28.0.1
                                                          platforms;android-28
                                                          platforms;android-25
                                                          extras;google;google_play_services
                                                          extras;google;m2repository
                                                          extras;android;m2repository )

default['android-sdk']['license']['white_list']     = %w(.+)
default['android-sdk']['license']['black_list']     = []    # e.g. ['intel-.+', 'mips-.+', 'android-wear-sdk-license-.+']
default['android-sdk']['license']['default_answer'] = 'n'   # 'y' or 'n' ('yes' or 'no')

default['android-sdk']['scripts']['path']           = '/usr/local/bin'
default['android-sdk']['scripts']['owner']          = node['android-sdk']['owner']
default['android-sdk']['scripts']['group']          = node['android-sdk']['group']

default['android-sdk']['java_from_system']          = false

default['android-sdk']['maven-rescue']              = false

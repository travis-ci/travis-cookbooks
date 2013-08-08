default['android-sdk']['name']           = 'android-sdk'
default['android-sdk']['owner']          = 'root'
default['android-sdk']['group']          = 'root'
default['android-sdk']['setup_root']     = nil		# ark defaults (/usr/local) is used if this attribute is not defined


# # Last version without License Agreement being prompted during setup:
# default['android-sdk']['version']        = '21.1'
# default['android-sdk']['checksum']       = '276e3c13a10f37927d4e04d036a94a0cbbf62326981f0ba61a303b76567e3379'

default['android-sdk']['version']        = '22.0.5'
default['android-sdk']['checksum']       = 'b664d1024b6fcf897e05eb1674c998df0ed2e4c9c280469445d914f8fcfa4454'

default['android-sdk']['download_url']   = "http://dl.google.com/android/android-sdk_r#{node['android-sdk']['version']}-linux.tgz"

# List of Android SDK components to preinstall:
default['android-sdk']['components']     = %w(platform-tools build-tools-18.0.1 android-18 sysimg-18 android-17 sysimg-17 android-16 sysimg-16 extra-android-support extra-google-google_play_services extra-google-m2repository extra-android-m2repository)

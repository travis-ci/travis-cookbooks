name             "android-ndk"
maintainer       "Kamil Trzciński"
maintainer_email "ayufan@ayufan.eu"
license          "Apache 2.0"
description      "Installs Google Android NDK"
version          "0.1.0"

%w{ ark }.each do |dep|
  depends dep
end

supports 'ubuntu', '>= 12.04'

recipe "android-ndk::default", "Install Google Android NDK"

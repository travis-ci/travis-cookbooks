name             "android-sdk"
maintainer       "Gilles Cornu"
maintainer_email "foss@gilles.cornu.name"
license          "Apache 2.0"
description      "Installs Google Android SDK"
version          "0.1.0"

%w{ java ark }.each do |dep|
  depends dep
end

supports 'ubuntu', '>= 12.04'
# Support for more platforms is on the road (e.g. Debian, CentOS,...). 
# Watch https://github.com/gildegoma/chef-android-sdk/issues/5

recipe "android-sdk", "Install and update Google Android SDK"

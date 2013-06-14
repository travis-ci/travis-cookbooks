name             "android-sdk"
maintainer       "Travis CI Development Team"
maintainer_email "contact@travis-ci.org"
license          "Apache 2.0"
description      "Installs Google Android SDK"
version          "0.0.0" # draft mode

%w{ java ark }.each do |dep|
  depends dep
end

%w{ ubuntu debian centos redhat fedora scientific suse }.each do |os|
  supports os
end

recipe "android-sdk", "Install and update Google Android SDK (tools and platforms)"

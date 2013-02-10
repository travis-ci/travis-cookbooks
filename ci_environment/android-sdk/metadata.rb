maintainer       "Travis CI Development Team"
maintainer_email "contact@travis-ci.org"
license          "Apache 2.0"
description      "Installs Google Android SDK"
version          "0.1.0"

depends          "java"

%w{ ubuntu debian centos redhat fedora scientific suse }.each do |os|
  supports os
end

recipe "android-sdk", "Install and update Google Android SDK (tools and platforms)"

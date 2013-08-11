name             "android-sdk"
maintainer       "Gilles Cornu"
maintainer_email "foss@gilles.cornu.name"
license          "Apache 2.0"
description      "Installs Google Android SDK"
version          "0.0.1" # draft mode, will be set to 0.1.0 when ready for integration into Travis CI

%w{ java ark }.each do |dep|
  depends dep
end

#TODO: pending distros to validate/adapt for (RPM-x86_64/i686 ia32libs issu): debian centos redhat fedora scientific suse
%w{ ubuntu }.each do |os|
  supports os
end

recipe "android-sdk", "Install and update Google Android SDK"

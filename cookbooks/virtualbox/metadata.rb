name             "virtualbox"
maintainer       "The Travis CI Team"
maintainer_email "mathias@travis-ci.org"
license          "Apache 2.0"
description      "Installs VirtualBox"
version          "0.0.1"

%w{ ubuntu debian }.each do |os|
  supports os
end

depends "apt"

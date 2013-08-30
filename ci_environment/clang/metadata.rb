name              "clang"
maintainer        "Michael S. Klishin, Travis CI Development Team"
maintainer_email  "michael@defprotocol.org"
license           "Apache 2.0"
description       "Installs Clang"
version           "1.0.0"
recipe            "default", "Installs Clang via packages"
recipe            "tarball", "Installs Clang via official prebuilt binaries"

%w{ubuntu}.each do |os|
  supports os
end

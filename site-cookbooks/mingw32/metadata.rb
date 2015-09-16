name              "mingw32"
maintainer        "Scott J. Goldman"
maintainer_email  "scottjgo@gmail.com"
license           "Apache 2.0"
description       "Installs 32-bit MINGW C cross-compiler / build tools"
version           "1.0.0"
recipe            "mingw", "Installs 32-bit MINGW C cross-compiler and build tools on Linux"

%w{ ubuntu debian }.each do |os|
  supports os
end

maintainer        "Scott J. Goldman"
maintainer_email  "scottjgo@gmail.com"
license           "Apache 2.0"
description       "Installs CMake"
version           "1.0.0"
recipe            "cmake", "Installs CMake"

%w{ ubuntu debian }.each do |os|
  supports os
end

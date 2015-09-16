name             "nodejs"
maintainer       "Travis CI Development Team"
license          "Apache v2.0"
description      "Installs/Configures nodejs"

%w{ build-essential networking_basic }.each do |cb|
  depends cb
end
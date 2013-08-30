name             "gvm"
maintainer       "Travis CI Development Team"
license          "Apache v2.0"
description      "Installs/Configures gvm"

%w{ build-essential git mercurial }.each do |cb|
  depends cb
end
maintainer       "Travis CI Development Team"
maintainer_email "contact@travis-ci.org"
license          "BSD"
description      "Installs and configures redis server"
version          "1.0.0"
recipe           "redis", "Installs redis server."

%w{ubuntu debian}.each do |os|
  supports os
end

name             "timezone"
maintainer       "James Harton"
maintainer_email "james@sociable.co.nz"
license          "Apache 2.0"
description      "Configure the system timezone on Debian or Ubuntu."
version          "0.0.1"

%w{ ubuntu debian }.each do |os|
  supports os
end

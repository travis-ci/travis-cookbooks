name              "sqlite"
maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs sqlite"
version           "0.7.1"

recipe "sqlite", "Installs sqlite"

%w{ubuntu debian}.each do |os|
  supports os
end

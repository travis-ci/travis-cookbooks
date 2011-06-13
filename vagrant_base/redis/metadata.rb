maintainer        "Paper Cavalier"
maintainer_email  "code@papercavalier.com"
license           "Apache 2.0"
description       "Installs and configures Redis 2.2.4"
version           "2.2.4"

recipe "redis::source", "Installs redis from source and adds init script"

%w{ ubuntu debian }.each do |os|
  supports os
end

depends "build-essential"

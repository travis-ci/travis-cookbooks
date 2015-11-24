name              "git"
maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs git and/or sets up a Git server daemon"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.9.0"
recipe            "git", "Installs git"

%w{ ubuntu debian arch}.each do |os|
  supports os
end

%w{ runit apt }.each do |cb|
  depends cb
end

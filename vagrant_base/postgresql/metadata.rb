maintainer        "Travis CI Team"
maintainer_email  "michaelklishin@me.com"
license           "Apache 2.0"
description       "Installs and configures PostgreSQL for clients or servers"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.11.2"
recipe            "postgresql",                "Empty, use one of the other recipes"
recipe            "postgresql::client",        "Installs postgresql client package(s)"
recipe            "postgresql::server",        "Installs postgresql server packages, templates"

%w{ubuntu debian}.each do |os|
  supports os
end

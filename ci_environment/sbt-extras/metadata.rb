name             "sbt-extras"
maintainer       "Gilles Cornu"
maintainer_email "foss@gilles.cornu.name"
license          "Apache 2.0"
description      "Installs sbt-extras to ease the building of scala projects"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.3.0"

depends          "java"

conflicts        "typesafe-stack" # See http://community.opscode.com/cookbooks/typesafe-stack
conflicts        "chef-sbt"       # See http://community.opscode.com/cookbooks/chef-sbt

%w{ debian ubuntu centos redhat fedora scientific suse amazon freebsd mac_os_x }.each do |os|
  supports os
end

recipe "sbt-extras::default", "Downloads and installs sbt-extras script"

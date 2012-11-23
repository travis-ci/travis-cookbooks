maintainer       "Gilles Cornu"
maintainer_email "git@gilles.cornu.name"
license          "Apache 2.0"
description      "Installs sbt-extras to build scala projects with any sbt version you need"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.2.2"

depends          "java"
conflicts        "typesafe-stack"

%w{ debian ubuntu centos redhat fedora scientific suse amazon freebsd mac_os_x }.each do |os|
  supports os
end

recipe "sbt-extras", "Downloads and installs sbt-extras script"

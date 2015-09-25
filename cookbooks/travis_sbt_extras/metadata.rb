name 'travis_sbt_extras'
maintainer 'Gilles Cornu'
maintainer_email 'foss@gilles.cornu.name'
license 'Apache 2.0'
description 'Installs sbt-extras to ease the building of scala projects'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.3.0'

depends 'travis_java'

conflicts 'typesafe-stack' # See http://community.opscode.com/cookbooks/typesafe-stack
conflicts 'chef-sbt' # See http://community.opscode.com/cookbooks/chef-sbt

supports 'debian'
supports 'ubuntu'
supports 'centos'
supports 'redhat'
supports 'fedora'
supports 'scientific'
supports 'suse'
supports 'amazon'
supports 'freebsd'
supports 'mac_os_x'

recipe 'travis_sbt_extras::default', 'Downloads and installs sbt-extras script'

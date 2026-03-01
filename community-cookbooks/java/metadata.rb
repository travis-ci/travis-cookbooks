name              'java'
maintainer        'Agile Orbit'
maintainer_email  'info@agileorbit.com'
license           'Apache-2.0'
description       'Installs Java runtime.'
version           '1.50.0'

%w(
  debian
  ubuntu
  centos
  redhat
  scientific
  fedora
  amazon
  arch
  oracle
  freebsd
  windows
  suse
  opensuse
  opensuseleap
  xenserver
  smartos
  mac_os_x
  zlinux
).each do |os|
  supports os
end

depends 'apt'
depends 'windows'
depends 'homebrew'

source_url 'https://github.com/agileorbit-cookbooks/java'
issues_url 'https://github.com/agileorbit-cookbooks/java/issues'
chef_version '>= 12.1'

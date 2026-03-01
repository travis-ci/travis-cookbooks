name 'iptables'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache-2.0'
description 'Sets up iptables to use a script to maintain rules'
version '1.0.0'
%w(redhat centos debian ubuntu amazon scientific oracle amazon).each do |os|
  supports os
end

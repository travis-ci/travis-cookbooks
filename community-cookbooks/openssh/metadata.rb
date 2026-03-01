name 'openssh'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache-2.0'
description 'Installs and configures OpenSSH client and daemon'
version '2.0.0'

%w(amazon arch centos fedora freebsd oracle redhat scientific smartos suse ubuntu).each do |os|
  supports os
end

depends 'iptables', '>= 1.0'

source_url 'https://github.com/chef-cookbooks/openssh'
issues_url 'https://github.com/chef-cookbooks/openssh/issues'

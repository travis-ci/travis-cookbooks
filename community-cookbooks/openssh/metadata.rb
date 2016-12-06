name 'openssh'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache 2.0'
description 'Installs and configures OpenSSH client and daemon'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '2.0.0'

recipe 'openssh', 'Installs openssh'
recipe 'openssh::iptables', 'Set up iptables to allow SSH inbound'

%w(amazon arch centos fedora freebsd oracle redhat scientific smartos suse ubuntu).each do |os|
  supports os
end

depends 'iptables', '>= 1.0'

source_url 'https://github.com/chef-cookbooks/openssh' if respond_to?(:source_url)
issues_url 'https://github.com/chef-cookbooks/openssh/issues' if respond_to?(:issues_url)

#
# Cookbook Name:: wget
# Recipe:: default
#
# Copyright 2015, Travis CI GmbH
#
#

package 'wget' do
  action :purge
end

package 'pkg-config'

package 'libgnutls-dev'

ark 'wget' do
  url "http://ftp.gnu.org/gnu/wget/wget-#{node.wget.version}.tar.gz"
  version node.wget.version
  action :install_with_make
end
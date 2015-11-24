#
# Cookbook Name:: jq
# Recipe:: default
#
# Copyright 2014, Travis CI GmbH
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

arch = node['kernel']['machine'] =~ /x86_64/ ? '64' : '32'
os = case node['platform_family']
     when 'mac_os_x' then 'osx'
     when 'omnios', 'smartos', 'solaris2' then 'solaris11-'
     else 'linux'
     end

remote_file node['jq']['install_dest'] do
  source "http://stedolan.github.io/jq/download/#{os}#{arch}/jq"
  action :create_if_missing
  mode 0755
  owner node['jq']['owner']
  group node['jq']['group']
end

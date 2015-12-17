# Cookbook Name:: travis_build_environment
# Recipe:: cloud_init
# Copyright 2011-2015, Travis CI GmbH <contact+travis-cookbooks@travis-ci.org>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# XXX: this does not work, probably because the apt cookbook in here is
# XXX: fairly outdated, so instead we do the `execute` resource just below.
# apt_repository 'pollinate' do
#   uri 'ppa:pollinate/ppa'
#   distribution node['lsb']['codename']
#   action :add
# end

execute 'apt-add-repository -y ppa:pollinate/ppa'

execute 'apt-get update for pollinate' do
  command 'apt-get update'
end

package 'pollinate' do
  action [:install, :upgrade]
end

%w(
  /etc/cloud
  /etc/cloud/templates
).each do |dirname|
  directory dirname do
    mode 0755
  end
end

template '/etc/cloud/cloud.cfg' do
  source 'etc/cloud/cloud.cfg.erb'
  owner 'root'
  group 'root'
  mode 0644
end

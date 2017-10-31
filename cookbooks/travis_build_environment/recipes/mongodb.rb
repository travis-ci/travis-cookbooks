# Cookbook Name:: travis_build_environment
# Recipe:: mongodb
# Copyright 2017 Travis CI GmbH
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

apt_repository 'mongodb-3.4' do
  uri 'http://repo.mongodb.org/apt/ubuntu'
  distribution "#{node['lsb']['codename']}/mongodb-org/3.4"
  components %w[multiverse]
  keyserver 'hkp://keyserver.ubuntu.com'
  key '0C49F3730359A14518585931BC711F9BA15703C6'
  retries 2
  retry_delay 30
  not_if { node['kernel']['machine'] == 'ppc64le' }
end

package 'mongodb-org' do
  not_if { node['kernel']['machine'] == 'ppc64le' }
end

package 'mongodb' do
  notifies :stop, 'service[mongodb]', :immediately
  notifies :disable, 'service[mongodb]', :immediately
  only_if { node['kernel']['machine'] == 'ppc64le' }
end

service 'mongodb' do
  action :nothing
  only_if { node['kernel']['machine'] == 'ppc64le' }
end

service 'mongod' do
  action %i[stop disable]
  not_if { node['kernel']['machine'] == 'ppc64le' }
end

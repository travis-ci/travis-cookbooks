# Cookbook Name:: couchdb
# Recipe:: binary
# Copyright 2016, Travis CI Development Team <contact@travis-ci.org>
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

couchdb_tarball = ::File.join(
  Chef::Config[:file_cache_path],
  "couchdb-#{node['couchdb']['binary_version']}.tar.bz2"
)

remote_file couchdb_tarball do
  source ::File.join(
    'https://s3.amazonaws.com/travis-couchdb-archives/binaries',
    node['platform'],
    node['platform_version'],
    node['kernel']['machine'],
    ::File.basename(couchdb_tarball)
  )
  owner 'root'
  group 'root'
  mode 0644
end

execute "tar -C / -xjf #{couchdb_tarball.inspect}"

group 'couchdb' do
  action :create
end

user 'couchdb' do
  supports manage_home: true
  comment 'CouchDB Administrator'
  uid 113
  group 'couchdb'
  home '/var/lib/couchdb'
  shell '/bin/bash'
end

service 'couchdb' do
  action [:disable, :start]
end

file '/etc/init/couchdb.override' do
  content 'manual'
  owner 'root'
  group 'root'
  mode 0644
end

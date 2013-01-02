#
# Cookbook Name:: hbase
# Recipe:: cdh4
# Copyright 2012, Michael S. Klishin <michaelklishin@me.com>
# Copyright 2012-2013, Travis CI Development Team <contact@travis-ci.org>
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

include_recipe "java"

# Cloudera only provides 64 bit packages. MK.
apt_repository "cdh4" do
  uri          "http://archive.cloudera.com/cdh4/ubuntu/#{node['lsb']['codename']}/amd64/cdh"
  distribution "#{node['lsb']['codename']}-cdh4"
  components   ["contrib"]
  options      "arch=amd64"
  key          "http://archive.cloudera.com/cdh4/ubuntu/#{node['lsb']['codename']}/amd64/cdh/archive.key"

  action :add
end

package "hbase" do
  action :install
end

package "hbase-master" do
  action :install
end

service "hbase-master" do
  supports :start => true, :stop => true, :restart => true
  action [:disable, :start]
end

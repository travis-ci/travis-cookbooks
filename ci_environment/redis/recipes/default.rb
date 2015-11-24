#
# Cookbook Name:: redis
# Recipe:: default
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

apt_repository "rwky-redis" do
  uri          "http://ppa.launchpad.net/rwky/redis/ubuntu"
  distribution node['lsb']['codename']
  components   ["main"]
  key          "5862E31D"
  keyserver    "keyserver.ubuntu.com"

  action :add
end

package "redis-server" do
  action :install
end

service "redis-server" do
  provider Chef::Provider::Service::Upstart
  supports :restart => true, :status => true, :reload => true
  if node.redis.service.enabled
    action [:enable, :start]
  else
    action [:disable, :start]
  end
end


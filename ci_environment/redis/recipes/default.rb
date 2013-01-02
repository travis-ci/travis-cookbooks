#
# Cookbook Name:: redis
# Recipe:: default
# Copyright 2011-2013, Travis CI Development Team <contact@travis-ci.org>
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

require "tmpdir"

user "redis" do
  system true

  action :create
end


%w(/var/lib/redis, /var/log/redis).each do |dir|
  directory(dir) do
    owner "redis"
    group "redis"

    action :create
  end
end

tmp = Dir.tmpdir
case node[:platform]
when "debian", "ubuntu"
  deb  = "redis.deb"
  path = File.join(tmp, deb)

  remote_file(path) do
    source node[:redis][:package][:url]
    owner  node.travis_build_environment.user
    group  node.travis_build_environment.group
  end

  package(deb) do
    action   :install
    source   path
    provider Chef::Provider::Package::Dpkg
  end

  service "redis-server" do
    supports :restart => true, :status => true, :reload => true
    if node.redis.service.enabled
      action [:enable, :start]
    else
      action [:disable, :start]
    end
  end
end # case

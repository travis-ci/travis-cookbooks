#
# Cookbook Name:: redis
# Recipe:: default
# Copyright 2011, Travis CI development team
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
  # this assumes 32-bit base Vagrant box.
  # built via brew2deb, http://bit.ly/brew2deb. MK.
  %w(redis2-server_2.2.12+github1_i386.deb).each do |deb|
    path = File.join(tmp, deb)

    cookbook_file(path) do
      owner "vagrant"
      group "vagrant"
    end

    package(deb) do
      action   :install
      source   path
      provider Chef::Provider::Package::Dpkg
    end
  end # each

  bash "update rc.d" do
    code <<-CODE
    sudo update-rc.d redis-server defaults
    sudo service redis-server start
    CODE
    user "root"

    subscribes :run, resources(:package => "redis2-server_2.2.12+github1_i386.deb"), :immediately
  end

  service "redis-server" do
    supports :restart => true, :status => true, :reload => true
    action [:enable, :start]
  end
end # case

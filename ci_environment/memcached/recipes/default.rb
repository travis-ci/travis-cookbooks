#
# Cookbook Name:: memcached
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
# Copyright 2011-2013, Travis CI Development Team <contact@travis-ci.org>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package "memcached" do
  action :upgrade
end

%w(libmemcached-dev libsasl2-dev).each do |pkg|
  package(pkg) do
    action :upgrade
  end
end

service "memcached" do
  supports :status => true, :start => true, :stop => true, :restart => true
  if node[:memcached][:enabled]
    action [:enable, :start]
  else
    action [:disable, :start]
  end
end

template "/etc/memcached.conf" do
  source "memcached.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :listen => node[:memcached][:listen],
    :user => node[:memcached][:user],
    :port => node[:memcached][:port],
    :memory => node[:memcached][:memory],
    :sasl   => node.memcached.sasl
  )
  notifies :restart, resources(:service => "memcached"), :immediately
end

case node[:lsb][:codename]
when "karmic"
  template "/etc/default/memcached" do
    source "memcached.default.erb"
    owner "root"
    group "root"
    mode "0644"
    notifies :restart, resources(:service => "memcached"), :immediately
  end
end

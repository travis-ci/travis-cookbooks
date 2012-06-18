#
# Cookbook Name:: firebird
# Recipe:: default
#
# Copyright 2012, Erik Frèrejean - erikfrerejean@phpbb.com
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

# Due to a bug in firebird 2.5, it is needed to fetch 2.5.1 from the ppa repository
# https://help.ubuntu.com/community/Firebird2.5
apt_repository "mapopa" do
  uri          "http://ppa.launchpad.net/mapopa/ppa/ubuntu/"
  distribution node['lsb']['codename']
  components   ["main"]

  key          "EF648708"
  keyserver    "keyserver.ubuntu.com"

  action :add
end

package "firebird2.5-super" do
  action :install
end

package "firebird2.5-dev" do
  action :install
end

template "/etc/firebird/2.5/SYSDBA.password" do
  owner "root"
  group "root"
  mode "0644"

  source "SYSDBA.password.erb"
end

template "/etc/firebird/2.5/firebird.conf" do
  owner "root"
  group "root"
  mode "0644"

  source "firebird.conf.erb"
end

# Creating this file will allow the service to be started without running
# `dpkg-reconfigure firebird2.5-super`
template "/etc/default/firebird2.5" do
  owner "root"
  group "root"
  mode "0644"

  source "default.firebird.erb"
end

service "firebird2.5-super" do
  action [:disable]
end


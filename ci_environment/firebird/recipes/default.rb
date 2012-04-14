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

package "firebird2.5-super" do
	action :upgrade
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

service "firebird2.5-super" do
  action [:disable]
end


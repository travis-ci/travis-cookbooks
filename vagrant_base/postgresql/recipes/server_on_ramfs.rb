#
# Cookbook Name:: postgresql
# Recipe:: server_on_ramfs
#
# Copyright 2011, Travis CI Development Team
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

include_recipe "ramfs"

node[:postgresql][:data_dir] = "#{node[:ramfs][:dir]}/postgresql"

include_recipe "postgresql::server"

template "/etc/init.d/postgresql" do
  source "ramfs.init.erb"
  owner "root"
  group "root"
  mode "0755"
  notifies :restart, resources(:service => "postgresql")
end

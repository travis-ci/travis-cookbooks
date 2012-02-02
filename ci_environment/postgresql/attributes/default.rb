#
# Cookbook Name:: postgresql
# Attributes:: postgresql
#
# Copyright 2008-2009, Opscode, Inc.
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
case platform
when "debian"
  default[:postgresql][:version] = if platform_version.to_f == 5.0
                                     "8.3"
                                   elsif platform_version =~ /.*sid/
                                     "8.4"
                                   end

  set[:postgresql][:dir] = "/etc/postgresql/#{node[:postgresql][:version]}/main"
  set[:postgresql][:data_dir] = "/var/lib/postgresql/#{node[:postgresql][:version]}/main"
when "ubuntu"
  default[:postgresql][:version] = if platform_version.to_f <= 9.04
                                     "8.3"
                                   elsif platform_version.to_f >= 11.10
                                     "9.1"
                                   else
                                     "8.4"
                                   end

  default[:postgresql][:ssl] = (default[:postgresql][:version].to_f >= 8.4)

  set[:postgresql][:dir] = "/etc/postgresql/#{node[:postgresql][:version]}/main"
  set[:postgresql][:data_dir] = "/var/lib/postgresql/#{node[:postgresql][:version]}/main"
when "fedora"
  default[:postgresql][:version] = if platform_version.to_f <= 12
                                     "8.3"
                                   else
                                     "8.4"
                                   end

  set[:postgresql][:dir] = "/var/lib/pgsql/data"
when "redhat","centos"
  default[:postgresql][:version] = "8.4"
  set[:postgresql][:dir] = "/var/lib/pgsql/data"
when "suse"
  default[:postgresql][:version] = if platform_version.to_f <= 11.1
                                     "8.3"
                                   else
                                     "8.4"
                                   end

  set[:postgresql][:dir] = "/var/lib/pgsql/data"
else
  default[:postgresql][:version] = "8.4"
  set[:postgresql][:dir]            = "/etc/postgresql/#{node[:postgresql][:version]}/main"
end

# in pages
default[:sysctl][:kernel_shmall] = 32768
# in bytes
default[:sysctl][:kernel_shmmax] = 134217728

default[:postgresql][:max_connections] = 512

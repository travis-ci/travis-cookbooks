#
# Cookbook Name:: apt
# Recipe:: default
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

execute "apt-get update" do
  action :run
end
execute "apt-get -y clean autoremove" do
  action :nothing
end

# for recipes that require preseeding, e.g. java::oraclejdk7, to work. MK.
package "debconf-utils" do
  action :install
end

# for convenience of those who add various PPAs. MK.
package "python-software-properties" do
  action :install
end

template "/etc/apt/sources.list" do
  source "sources.list.erb"

  mode   0644

  notifies :run, resources(:execute => "apt-get update"), :immediately

  # cleans up at the end of Chef run
  notifies :run, resources(:execute => "apt-get -y clean autoremove")
end

%w{/var/cache/local /var/cache/local/preseeding}.each do |dirname|
  directory dirname do
    owner "root"
    group "root"
    mode  0755
    action :create
  end
end

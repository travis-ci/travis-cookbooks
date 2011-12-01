#
# Cookbook Name:: mysql
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

# IMPORTANT: this recipe is only really needed by the Ruby on Rails test suite
#            that is very I/O demanding. It places MySQL'd data dir to a ramfs mount
#            and copies existing data dir there so that system catalogs are in place, then
#            restarts mysqld once again. Copying & restart also will happen once again on boot.
#            This whole sequence is indeed hacky and needs extra care. But c'est la vie,
#            ActiveRecord test suite runs x3 times faster with this recipe in place. MK.
#


# A detailed description of the madness:
# 1. Install MySQL as usual, using mysql::server.
# 2. Set up users, again, as part of mysql::server.
# 3. Mount /var/ramfs, copy mysql datadir there
# 4. Swap my.cnf with another version that uses /var/ramfs/mysql for datadir
# 5. Install a custom Upstart configuration file
# 6. Restart MySQL at the end of the Chef run
#
#

require "fileutils"

include_recipe "ramfs"

# next, install the packages, do pre-seeding, restart mysqld all from a regular
# ext3 mount.

include_recipe "mysql::server"

log "['mysql']['data_dir'] = #{node['mysql']['data_dir']}"
log "[:mysql][:data_dir] = #{node[:mysql][:data_dir]}"

bash "cp -R #{node['mysql']['data_dir']} #{node[:ramfs][:dir]}/mysql" do
  code "cp -R #{node['mysql']['data_dir']} #{node[:ramfs][:dir]}/mysql && chown -R mysql:mysql #{node[:ramfs][:dir]}/mysql"

  # run this bash snippet only after mysql-install-privileges has run, but not earlier
  subscribes :run, resources(:execute => "mysql-install-privileges"), :immediately
end

# Now install a custom my.cnf that will use a ramfs directory for datadir.
template "#{node['mysql']['conf_dir']}/my.cnf" do
  source "ramfs/my.cnf.erb"

  owner "root"
  group "root"
  mode "0644"

  # install this template only after mysql-install-privileges has run, but not earlier
  subscribes :create, resources(:execute => "mysql-install-privileges"), :immediately
  # yes, notify about restart at the end of Chef run and NOT immediately
  notifies :restart, resources(:service => "mysql"), :delayed
end


# Tweak Upstart job script to copy /var/lib/mysql => /var/ramfs/mysql before
# starting mysqld up.
template "/etc/init/mysql.conf" do
  source "init/mysql.conf.erb"
  owner "root"
  group "root"
  mode "0644"

  # install this template only after mysql-install-privileges has run, but not earlier
  subscribes :create, resources(:execute => "mysql-install-privileges"), :immediately
end

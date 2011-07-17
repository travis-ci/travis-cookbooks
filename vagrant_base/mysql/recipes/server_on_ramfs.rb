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


require "fileutils"

# first, set up /var/ramfs
directory(node[:ramfs]) do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

mount "/var/ramfs" do
  fstype   "ramfs"
  device   "/dev/null" # http://tickets.opscode.com/browse/CHEF-1657
  options  "defaults,size=256m,noatime"
  action   [:mount, :enable]
end

# next, install the packages, do pre-seeding, restart mysqld all from a regular
# ext3 mount.
#
# Cookbook Name:: mysql
# Recipe:: server
#
# Copyright 2008-2011, Opscode, Inc.
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

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

include_recipe "mysql::client"

# for CI environment, blank passwords make sense
node.set_unless['mysql']['server_debian_password'] = ""
node.set_unless['mysql']['server_root_password']   = ""
node.set_unless['mysql']['server_repl_password']   = ""

package "mysql-server" do
  action :install
end

previous_data_dir      = node['mysql']['data_dir'].dup
new_data_dir           = "#{node[:ramfs]}/mysql"
#node[:mysql][:datadir] = new_data_dir



if platform?(%w{debian ubuntu})
  directory "/var/cache/local/preseeding" do
    owner "root"
    group "root"
    mode 0755
    recursive true
  end

  execute "preseed mysql-server" do
    command "debconf-set-selections /var/cache/local/preseeding/mysql-server.seed"
    action :nothing
  end

  template "/var/cache/local/preseeding/mysql-server.seed" do
    source "mysql-server.seed.erb"
    owner "root"
    group "root"
    mode "0600"
    notifies :run, resources(:execute => "preseed mysql-server"), :immediately
  end

  template "#{node['mysql']['conf_dir']}/debian.cnf" do
    source "debian.cnf.erb"
    owner "root"
    group "root"
    mode "0600"
  end

  # copies existing mysql datadir to the ramfs volume.
  template "/etc/init/mysql.conf" do
    source "init/mysql.conf.erb"
    owner "root"
    group "root"
    mode "0644"
  end
end


service "mysql" do
  service_name value_for_platform([ "centos", "redhat", "suse", "fedora" ] => {"default" => "mysqld"}, "default" => "mysql")
  if (platform?("ubuntu") && node.platform_version.to_f >= 10.04)
    restart_command "restart mysql"
    stop_command "stop mysql"
    start_command "start mysql"
  end
  supports :status => true, :restart => true, :reload => true
  action :nothing
end



# set the root password on platforms
# that don't support pre-seeding
unless platform?(%w{debian ubuntu})
  execute "assign-root-password" do
    command "/usr/bin/mysqladmin -u root password \"#{node['mysql']['server_root_password']}\""
    action :run
    only_if "/usr/bin/mysql -u root -e 'show databases;'"
  end
end

grants_path = "#{node['mysql']['conf_dir']}/mysql_grants.sql"

begin
  t = resources("template[#{grants_path}]")
rescue
  Chef::Log.info("Could not find previously defined grants.sql resource")
  t = template grants_path do
    source "grants.sql.erb"
    owner "root"
    group "root"
    mode "0600"
    action :create
  end
end

execute "mysql-install-privileges" do
  command "/usr/bin/mysql -u root #{node['mysql']['server_root_password'].empty? ? '' : '-p' }#{node['mysql']['server_root_password']} < #{grants_path}"
  action :nothing
  subscribes :run, resources("template[#{grants_path}]"), :immediately

  # This is intentional, makes provisioning idempotent/re-entrant. antares_, svenfuchs.
  ignore_failure true
end


bash "cp -R #{previous_data_dir} #{new_data_dir}" do
  code "cp -R #{previous_data_dir} #{new_data_dir}"
end
bash "chown -R mysql:mysql #{new_data_dir}" do
  code "chown -R mysql:mysql #{new_data_dir}"
end

node[:mysql][:data_dir] = new_data_dir

template "#{node['mysql']['conf_dir']}/my.cnf" do
  source "my.cnf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "mysql")#, :immediately
end

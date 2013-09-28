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

include_recipe "mysql::client"

# yes, for the CI environment, empty password is a good idea. VM is rolled back after eack run anyway.
node.set_unless['mysql']['server_debian_password'] = ""
node.set_unless['mysql']['server_root_password']   = ""
node.set_unless['mysql']['server_repl_password']   = ""

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
end

# wipe out apparmor on 11.04 and later, it prevents MySQLd from restarting for now
# good reasons (as far as CI goes). MK.
package "apparmor" do
  action :remove
  ignore_failure true
end

package "apparmor-utils" do
  action :remove
  ignore_failure true
end

package "mysql-server" do
  action :install
end

service "mysql" do
  service_name value_for_platform([ "centos", "redhat", "suse", "fedora" ] => {"default" => "mysqld"}, "default" => "mysql")

  if (platform?("ubuntu") && node.platform_version.to_f >= 11.04)
    provider Chef::Provider::Service::Upstart
  end
  supports :status => true, :restart => true, :reload => true
  if node['mysql']['enabled']
    action :enable
  else
    action :disable
  end
end

template "#{node['mysql']['conf_dir']}/my.cnf" do
  source "my.cnf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[mysql]", :immediately
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

#
# Cookbook Name:: mysql
# Recipe:: server
#
# Copyright 2008-2011, Opscode, Inc.
# Copyright 2015, Travis CI GmbH
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

# yes, for the CI environment, empty password is a good idea. VM is rolled back after eack run anyway.
node.set_unless['mysql']['server_debian_password'] = ""
node.set_unless['mysql']['server_root_password']   = ""
node.set_unless['mysql']['server_repl_password']   = ""

# Install prerequisites, including apparmor, which is installed here,
# only to satisfy the *.deb packages' requirements
package 'libaio1'
package 'apparmor'
package 'apparmor-utils'

###
# Install MySQL server from deb packages from mysql.com
###
version = node.mysql.deb.version
version_major_minor = /^\d+\.\d+/.match(version)[0]

apt_config_file = File.join(Chef::Config[:file_cache_path], 'mysql-apt-config.deb')

remote_file apt_config_file do
  source "http://dev.mysql.com/get/mysql-apt-config_#{node.mysql.deb.config.version}-2ubuntu#{node.platform_version}_all.deb"
end

# tar_path = File.join(Chef::Config[:file_cache_path], 'mysql-server-deb-bundle.tar')

# remote_file tar_path do
#   source "http://dev.mysql.com/get/Downloads/MySQL-#{version_major_minor}/mysql-server_#{version}-1ubuntu#{node.platform_version}_amd64.deb-bundle.tar"
#   checksum node.mysql.deb.checksum[node.platform_version][node.mysql.deb.version]
#   user node.travis_build_environment.user
#   not_if "test -f #{tar_path}"
# end

# bash "expand MySQL tar file" do
#   cwd File.dirname(tar_path)
#   user node.travis_build_environment.user
#   code "tar xf #{tar_path}"
#   not_if "ls #{File.dirname(tar_path)}/*mysql*.deb"
# end

# node.mysql.deb.server.packages.each do |pkg|
#   pkg_name = "#{pkg}_#{version}-1ubuntu#{node.platform_version}_amd64.deb"
#   dpkg_package pkg do
#     source File.join(File.dirname(tar_path), pkg_name)
#     action :install
#   end
# end

###

if platform?(%w{debian ubuntu})

  directory "/var/cache/local/preseeding" do
    owner "root"
    group "root"
    mode 0755
    recursive true
  end

  execute "preseed mysql-apt-config" do
    command "debconf-set-selections /var/cache/local/preseeding/mysql-apt-config.seed"
    action :nothing
  end

  template "/var/cache/local/preseeding/mysql-apt-config.seed" do
    source "mysql-apt-config.seed.erb"
    owner "root"
    group "root"
    mode "0600"
    notifies :run, resources(:execute => "preseed mysql-apt-config"), :immediately
  end

  execute "preseed mysql-server" do
    command "debconf-set-selections /var/cache/local/preseeding/mysql-server.seed"
    action :nothing
  end

  template "/var/cache/local/preseeding/mysql-server.seed" do
    source "mysql-server-deb.seed.erb"
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

# Remove apparmor again, to put this recipe in line with 'mysql::server'
package "apparmor" do
  action :remove
  ignore_failure true
end

package "apparmor-utils" do
  action :remove
  ignore_failure true
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

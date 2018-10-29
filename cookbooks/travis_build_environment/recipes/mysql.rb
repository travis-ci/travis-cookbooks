# frozen_string_literal: true

# Cookbook Name:: travis_build_environment
# Recipe:: mysql
# Copyright 2017 Travis CI GmbH
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

package %w[
  mysql-client-5.5
  mysql-client-core-5.5
  mysql-common
  mysql-server-5.5
] do
  action %i[remove purge]
end

%w[
  root_password
  root_password_again
].each do |selection|
  execute "echo 'mysql-server-5.6 mysql-server/#{selection} password ' | debconf-set-selections"
end

mysql_version = 5.6
mysql_pkgs =  %w[
  libmysqlclient-dev
  libmysqlclient18
  mysql-client-5.6
  mysql-client-core-5.6
  mysql-common-5.6
  mysql-server-5.6
  mysql-server-core-5.6
]
if node['lsb']['codename'] == 'xenial'
  mysql_version = 5.7
  mysql_pkgs = %w[
    libmysqlclient-dev
    libmysqlclient20
    mysql-client-5.7
    mysql-client-core-5.7
    mysql-common
    mysql-server-5.7
    mysql-server-core-5.7
  ]
end

package mysql_pkgs do
  action %i[install upgrade]
end

mysql_users_passwords_sql = ::File.join(
  Chef::Config[:file_cache_path],
  'mysql_users_passwords.sql'
)

mysql_user_passwords_sql_content = [
  "SET old_passwords = 0",
  "CREATE USER 'travis'@'%' IDENTIFIED BY ''",
  "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('')",
  "GRANT ALL PRIVILEGES ON *.* TO 'travis'@'%'",
  "CREATE USER 'travis'@'localhost' IDENTIFIED BY ''",
  "GRANT ALL PRIVILEGES ON *.* TO 'travis'@'localhost'",
  "CREATE USER 'travis'@'127.0.0.1' IDENTIFIED BY ''",
  "GRANT ALL PRIVILEGES ON *.* TO 'travis'@'127.0.0.1'"
]

if mysql_version < 5.7
  mysql_user_passwords_sql_content << "SET PASSWORD FOR 'root'@'127.0.0.1' = PASSWORD('')"
elsif mysql_version == 5.7
  mysql_user_passwords_sql_content << "UPDATE mysql.user SET plugin = 'mysql_native_password' WHERE User = 'root'; FLUSH PRIVILEGES;"
end

file mysql_users_passwords_sql do
  content mysql_user_passwords_sql_content.join(';')
end

template "/etc/mysql/conf.d/innodb_flush_log_at_trx_commit.cnf" do
  source 'root/innodb_flush_log_at_trx_commit.cnf.erb'
  owner 'root'
  group 'root'
  mode 0o644
end

template "/etc/mysql/conf.d/performance-schema.cnf" do
  source 'root/performance-schema.cnf.erb'
  owner 'root'
  group 'root'
  mode 0o644
end

template "#{node['travis_build_environment']['home']}/.my.cnf" do
  source 'ci_user/dot_my.cnf.erb'
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o640
  variables(socket: node['travis_build_environment']['mysql']['socket'])
end

start_cmd = node['init_package'] == 'systemd' ? 'systemctl start mysql' : 'service mysql start'

bash 'setup mysql users and passwords' do
  code <<-EOCODE
    #{start_cmd}
    sleep 1
    if ! mysql -u root <#{mysql_users_passwords_sql}; then
      tail -n 1000 /var/log/mysql/*
      false
    fi
  EOCODE
end

include_recipe 'travis_build_environment::bash_profile_d'

file ::File.join(
  node['travis_build_environment']['home'],
  '.bash_profile.d/travis-mysql.bash'
) do
  content "export MYSQL_UNIX_PORT=#{node['travis_build_environment']['mysql']['socket']}\n"
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o644
end

service 'mysql' do
  action %i[disable stop]
end

# Cookbook Name:: travis_build_environment
# Recipe:: mysql
# Copyright 2011-2015, Travis CI GmbH <contact+travis-cookbooks@travis-ci.org>
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

package %w(mysql-client-5.5 mysql-client-core-5.5 mysql-server-5.5) do
  action %i(remove purge)
end

mysql_client '5.6' do
  version '5.6'
end

mysql_service '5.6' do
  port '3306'
  version '5.6'
  initial_root_password node['travis_build_environment']['mysql']['password']
  action %i(create start stop)
end

template "#{node['travis_build_environment']['home']}/.my.cnf" do
  source 'ci_user/dot_my.cnf.erb'
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o640
  variables(
    password: node['travis_build_environment']['mysql']['password']
  )
end

%w(
  /var/run/mysqld/mysqld.sock
  /run/mysqld/mysqld.sock
).each do |from|
  directory ::File.dirname(from) do
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    mode 0o750
    recursive true
  end

  link from do
    to '/run/mysql-5.6/mysqld.sock'
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
  end
end

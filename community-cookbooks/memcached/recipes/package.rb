#
# Cookbook Name:: memcached
# Recipe:: default
#
# Copyright 2009-2013, Chef Software, Inc.
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

# include epel on redhat/centos 5 and below in order to get the memcached packages
include_recipe 'yum-epel' if node['platform_family'] == 'rhel' && node['platform_version'].to_i == 5

if node['platform_family'] == 'debian' && shell_out('dpkg -l memcached | grep "^ii  memcached"').error?
  # dpkg, imma let you finish but don't start services automatically
  # https://jpetazzo.github.io/2013/10/06/policy-rc-d-do-not-start-services-automatically/
  execute 'disable auto-start' do
    command 'echo exit 101 > /usr/sbin/policy-rc.d ; chmod +x /usr/sbin/policy-rc.d'
  end

  package 'memcached' do
    version node['memcached']['version']
    action :install
  end

  execute 'undo service disable hack' do
    command 'echo exit 0 > /usr/sbin/policy-rc.d'
  end

else
  package 'memcached' do
    version node['memcached']['version']
    action :install
  end
end


package 'libmemcache-dev' do
  case node['platform_family']
  when 'rhel', 'fedora'
    package_name 'libmemcached-devel'
  when 'smartos'
    package_name 'libmemcached'
  when 'suse'
    if node['platform_version'].to_f < 12
      package_name 'libmemcache-devel'
    else
      package_name 'libmemcached-devel'
    end
  when 'debian'
    package_name 'libmemcached-dev'
  else
    package_name 'libmemcache-dev'
  end
end

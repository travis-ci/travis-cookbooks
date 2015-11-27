#
# Cookbook Name:: mongodb
# Recipe:: 10gen_repo
#
# Copyright 2011, edelight GmbH
# Authors:
#       Miquel Torres <miquel.torres@edelight.de>
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

# Sets up the repositories for stable mongodb-org packages found here:
# http://www.mongodb.org/downloads#packages
node.override['mongodb']['package_name'] = 'mongodb-org'

case node['platform_family']
when 'debian'
  # Adds the repo: http://www.mongodb.org/display/DOCS/Ubuntu+and+Debian+packages
  apt_repository 'mongodb' do
    uri "http://downloads-distro.mongodb.org/repo/#{node[:mongodb][:apt_repo]}"
    distribution 'dist'
    components ['10gen']
    keyserver 'hkp://keyserver.ubuntu.com:80'
    key '7F0CEB10'
    action :add
  end

when 'rhel', 'fedora'
  yum_repository 'mongodb' do
    description 'mongodb RPM Repository'
    baseurl "http://downloads-distro.mongodb.org/repo/redhat/os/#{node['kernel']['machine']  =~ /x86_64/ ? 'x86_64' : 'i686'}"
    action :create
    gpgcheck false
    enabled true
  end

else
  # pssst build from source
  Chef::Log.warn("Adding the #{node['platform_family']} 10gen repository is not yet not supported by this cookbook")
end

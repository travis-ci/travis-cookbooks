#
# Cookbook Name:: erlang
# Recipe:: default
# Author:: Joe Williams <joe@joetify.com>
# Author:: Matt Ray <matt@chef.io>
# Author:: Hector Castro <hector@basho.com>
#
# Copyright 2008-2009, Joe Williams
# Copyright 2011, Chef Software Inc.
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

case node['platform_family']
when 'debian'
  erlpkg = node['erlang']['gui_tools'] ? 'erlang-x11' : 'erlang-nox'
  package erlpkg
  package 'erlang-dev'

when 'rhel'
  if node['platform_version'].to_i == 5
    Chef::Log.warn('Adding EPEL Erlang Repo. This will have SSL verification disabled, as')
    Chef::Log.warn('RHEL/CentOS 5.x will not be able to verify the SSL certificate of this')
    Chef::Log.warn('repository despite it being valid because yum on does not correctly')
    Chef::Log.warn('follow the HTTP redirect.')

    yum_repository 'EPELErlangrepo' do
      description "Updated erlang yum repository for RedHat / Centos 5.x - #{node['kernel']['machine']}"
      baseurl 'http://repos.fedorapeople.org/repos/peter/erlang/epel-5Server/$basearch'
      gpgcheck false
      sslverify false
      action :create
    end
  end

  include_recipe 'yum-epel'
  package 'erlang'
end

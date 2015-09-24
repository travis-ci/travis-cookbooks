#
# Author:: Travis CI Development Team
# Cookbook Name:: travis_java
# Recipe:: default
#
# Copyright 2008-2011, Opscode, Inc.
# Copyright 2011-2015, Travis CI Development Team <contact@travis-ci.org>
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

package 'unzip'

default_jvm = nil

unless node['travis_java']['default_version'] == ''
  Chef::Log.info("Installing Java #{node['travis_java']['default_version']}.")
  include_recipe "java::#{node['travis_java']['default_version']}"
  default_jvm = node['travis_java'][node['travis_java']['default_version']]['jvm_name']
end

unless Array(node['travis_java']['alternate_versions']).empty?
  include_recipe 'java::multi'
end

execute "Set #{default_jvm} as default alternative" do
  command "update-java-alternatives -s #{default_jvm}"
  not_if { default_jvm.nil? }
end

template '/etc/profile.d/java_home.sh' do
  source 'etc/profile.d/java_home.sh.erb'
  owner 'root'
  group 'root'
  mode 0644
  not_if { default_jvm.nil? }
end

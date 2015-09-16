#
# Cookbook Name:: maven
# Recipe:: default
#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
#
# Copyright:: 2010-2012, Opscode, Inc.
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

include_recipe 'java::default'
include_recipe 'ark::default'

mvn_version = node['maven']['version'].to_s

ark 'maven' do
  url      node['maven'][mvn_version]['url']
  checksum node['maven'][mvn_version]['checksum']
  home_dir node['maven']['m2_home']
  version  node['maven'][mvn_version]['version']
  append_env_path true
end

template '/etc/mavenrc' do
  source 'mavenrc.erb'
  mode   '0755'
end

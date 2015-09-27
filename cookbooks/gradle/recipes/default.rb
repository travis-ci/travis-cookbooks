# Cookbook Name:: gradle
# Recipe:: default
#
# Copyright 2012, Michael S. Klishin.
# Copyright 2013-2015, Travis CI GmbH
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

package %w(
  groovy
  unzip
)

ark 'gradle' do
  url node['gradle']['url']
  version node['gradle']['version']
  checksum node['gradle']['checksum']
  path node['gradle']['installation_dir']
  owner 'root'
end

cookbook_file '/etc/profile.d/gradle.sh' do
  source 'etc/profile.d/gradle.sh'
  owner 'root'
  group 'root'
  mode 0644
end

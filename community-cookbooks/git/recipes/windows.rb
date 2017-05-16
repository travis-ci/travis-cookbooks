#
# Cookbook:: git
# Recipe:: windows
#
# Copyright:: 2008-2016, Chef Software, Inc.
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

git_client 'default' do
  windows_display_name node['git']['display_name']
  windows_package_url format(node['git']['url'], version: node['git']['version'], architecture: node['git']['architecture'])
  windows_package_checksum node['git']['checksum']
  action :install
end

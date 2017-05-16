#
# Cookbook:: git
# Recipe:: source
#
# Copyright:: 2012-2016, Brian Flad, Fletcher Nichol
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

# drive version from node attributes
git_client 'default' do
  provider Chef::Provider::GitClient::Source
  source_checksum node['git']['checksum']
  source_prefix node['git']['prefix']
  source_url format(node['git']['url'], version: node['git']['version'])
  source_use_pcre node['git']['use_pcre']
  source_version node['git']['version']
  action :install
end

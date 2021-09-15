#
# Cookbook:: chef-sugar
# Recipe:: default
#
# Copyright:: 2013-2015, Seth Vargo <sethvargo@gmail.com>
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

gem_version = run_context.cookbook_collection[cookbook_name].metadata.version

if Chef::Resource::ChefGem.instance_methods(false).include?(:compile_time)
  chef_gem 'chef-sugar' do
    version gem_version
    compile_time true
  end
else
  chef_gem 'chef-sugar' do
    version gem_version
    action :nothing
  end.run_action(:install)
end

require 'chef/sugar'

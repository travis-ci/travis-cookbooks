#
# Cookbook Name:: ant
# Provider:: library
#
# Author:: Kyle Allan (<kallan@riotgames.com>)
# Copyright 2012, Riot Games
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

def load_current_resource
  @current_resource = Chef::Resource::AntLibrary.new(new_resource.name)
  @current_resource.url new_resource.url
end

action :install do
  unless ::File.exists?("#{node["ant"]["home"]}/lib/#{@current_resource.file_name}")
    remote_file remote_file_path do
      source new_resource.url
      mode "0755"
    end
    new_resource.updated_by_last_action(true)
  end
end

private

def remote_file_path
  "#{node["ant"]["home"]}/lib/#{new_resource.file_name}"
end

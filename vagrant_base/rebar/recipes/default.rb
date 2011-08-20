#
# Cookbook Name:: Rebar
# Recipe:: default
#
# Copyright 2011, Ward Bekker
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

include_recipe('kerl')

remote_file("/tmp/rebar.tar.gz") do
  source node.rebar.release  
  owner node.rebar.user
  group node.rebar.group
end

script "install rebar" do
  interpreter "bash"
  user node.rebar.user
  cwd "/tmp"
  code <<-EOH
      source /home/#{node.kerl.user}/otp/R14B01/activate
      tar xvf /tmp/rebar.tar.gz && cd /tmp/#{node.rebar.release_dir} && ./bootstrap && chmod +x rebar && sudo cp rebar #{node.rebar.path}
  EOH
end

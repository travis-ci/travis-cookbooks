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
end

execute "active an erlang installation with kerl" do
  command "otp=`kerl list installations | head -n 1 | cut -f2 -d\" \"` && source \"$otp/activate\""
end

execute "install rebar" do
  command "tar xvf /tmp/rebar.tar.gz rebar && cd /tmp/rebar && ./bootstrap && chmod +x rebar && sudo cp rebar #{node.rebar.path}"
end

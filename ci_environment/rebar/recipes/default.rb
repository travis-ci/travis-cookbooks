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

remote_file("/usr/local/bin/rebar") do
  source node.rebar.release
  owner  node.travis_build_environment.user
  group  node.travis_build_environment.group
  mode   0755
end

#
# Cookbook Name:: couchdb
# Recipe:: ppa
#
# Copyright 2012-2013, Travis CI Development Team <contact@travis-ci.org>
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

# This recipe relies on a PPA package and is Ubuntu/Debian specific. Please
# keep this in mind.

case [node[:platform], node[:platform_version]]
when ["ubuntu", "11.10"] then
  include_recipe "couchdb::ubuntu1110_ppa"
when ["ubuntu", "12.04"] then
  include_recipe "couchdb::ubuntu1204_ppa"
end

package "couchdb" do
  action :install
end

service "couchdb" do
  # intentionally disabled on boot. MK.
  action [:disable, :start]
end

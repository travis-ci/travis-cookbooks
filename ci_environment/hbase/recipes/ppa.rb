#
# Cookbook Name:: hbase
# Recipe:: ppa
#
# Copyright 2011-2012, Travis CI Development Team
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

include_recipe "java"

apt_repository "hbase-ppa" do
  uri          "http://ppa.launchpad.net/hadoop-ubuntu/dev/ubuntu"
  distribution node['lsb']['codename']
  components   ["main"]
  key          "84FBAFF0"
  keyserver    "keyserver.ubuntu.com"

  action :add
end

package "hbase" do
  action :install
end

# TODO: the package does not provide service script, we need to add one. MK.
# service "hbase" do
#   supports :restart => true, :status => true
#   # intentionally disabled on boot to save on RAM available to projects,
#   # supposed to be started manually by projects that need it. MK.
#   action [:disable]
# end

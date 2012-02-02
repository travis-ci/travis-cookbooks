#
# Cookbook Name:: maven3
# Recipe:: default
#
# Copyright 2011, Travis CI Development Team
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



include_recipe "java"

case node.platform
when "redhat", "centos", "fedora" then
  include_recipe "jpackage"
  include_recipe "maven3::tarball"
when "ubuntu", "debian" then
  case node.platform_version
  when "11.04" then
    include_recipe "maven3::tarball"
  when "11.10" then
    include_recipe "maven3::ppa"
  end
end

#
# Cookbook Name:: travis_java
# Recipe:: openjdk8
#
# Copyright 2014-2015, Travis CI Development Team
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

# As of Ubuntu 14.10 (Vivid), OpenJDK is available in main Ubuntu package repository
if Chef::VersionConstraint.new('<= 14.04').include?(node['platform_version'])
  include_recipe 'java::openjdk-r'
end

package 'openjdk-8-jdk'

# openjfx package is not available for precise (12.04)
# openjfx package is NOT YET available for trusty (14.04)
# See https://bugs.launchpad.net/ubuntu/+source/openjdk-8/+bug/1398660
if Chef::VersionConstraint.new('>= 14.10').include?(node['platform_version'])
  package 'openjfx'
end

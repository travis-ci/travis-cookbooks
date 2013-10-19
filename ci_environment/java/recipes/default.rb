#
# Author:: Travis CI Development Team
# Cookbook Name:: java
# Recipe:: default
#
# Copyright 2008-2011, Opscode, Inc.
# Copyright 2011-2013, Travis CI Development Team <contact@travis-ci.org>
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

#
# WARNING:
# All recipes of this cookbook are (currently) specifically designed for Ubuntu
# Please keep this in mind.
#


#
# Install the default JDK
#
Chef::Log.info("Installing Java #{node['java']['default_version']}.")
include_recipe "java::#{node['java']['default_version']}"
default_jvm = node['java'][node['java']['default_version']]['jvm_name']

#
# Install more JDKs, if requested.
#
if not node['java']['alternate_versions'].to_a.empty?
  # Note: 'multi' recipe is conditionally included to avoid the execution of
  #       openjdk6/tzdata workaround in single-jdk mode.
  #       This might change...
  include_recipe "java::multi"
end

#
# Ensure that default JDK is configured as default
#
execute "Set #{default_jvm} as default alternative" do
  command "update-java-alternatives -s #{default_jvm}"
end
template "/etc/profile.d/java_home.sh" do
  owner "root"
  group "root"
  mode 0644

  source "etc/profile.d/java_home.sh.erb"

  # Could be changed to following, if node.java.java_home attribute is removed one day...
  # variables({
  #   :java_home => File.join(node['java']['jvm_base_dir'], default_jvm)
  # })
end

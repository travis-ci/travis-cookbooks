# Author:: Christophe Arguel (<christophe.arguel@free.fr>)
#
# Cookbook:: java
# Recipe:: oracle_rpm
#
# Copyright:: 2013, Christophe Arguel <christophe.arguel@free.fr>
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

include_recipe 'java::set_java_home'
include_recipe 'java::notify'

slave_cmds = case node['java']['oracle_rpm']['type']
             when 'jdk'
               %w(appletviewer apt ControlPanel extcheck idlj jar jarsigner javac javadoc javafxpackager javah javap java-rmi.cgi javaws jcmd jconsole jcontrol jdb jhat jinfo jmap jps jrunscript jsadebugd jstack jstat jstatd jvisualvm keytool native2ascii orbd pack200 policytool rmic rmid rmiregistry schemagen serialver servertool tnameserv unpack200 wsgen wsimport xjc)

             when 'jre'
               %w(ControlPanel java_vm javaws jcontrol keytool orbd pack200 policytool rmid rmiregistry servertool tnameserv unpack200)

             else
               raise("Unsupported oracle RPM type (#{node['java']['oracle_rpm']['type']})")
             end

bash 'update-java-alternatives' do
  java_home = node['java']['java_home']
  java_location = File.join(java_home, 'bin', 'java')
  slave_lines = slave_cmds.inject('') do |slaves, cmd|
    slaves << "--slave /usr/bin/#{cmd} #{cmd} #{File.join(java_home, 'bin', cmd)} \\\n"
  end

  code <<-EOH.gsub(/^\s+/, '')
    update-alternatives --install /usr/bin/java java #{java_location} #{node['java']['alternatives_priority']} \
    #{slave_lines} && \
    update-alternatives --set java #{java_location}
  EOH
  action :nothing
end

package_name = node['java']['oracle_rpm']['package_name'] || node['java']['oracle_rpm']['type']
package package_name do
  action :install
  version node['java']['oracle_rpm']['package_version'] if node['java']['oracle_rpm']['package_version']
  notifies :run, 'bash[update-java-alternatives]', :immediately if platform_family?('rhel', 'fedora') && node['java']['set_default']
  notifies :write, 'log[jdk-version-changed]', :immediately
end

include_recipe 'java::oracle_jce' if node['java']['oracle']['jce']['enabled']

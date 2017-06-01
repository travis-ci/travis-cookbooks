#
# Author:: Kyle McGovern (<spion06@gmail.com>)
# Cookbook:: java
# Recipe:: oracle_jce
#
# Copyright:: 2014, Kyle McGovern
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_recipe 'java::set_attributes_from_version'

jdk_version = node['java']['jdk_version'].to_s
jce_url = node['java']['oracle']['jce'][jdk_version]['url']
jce_checksum = node['java']['oracle']['jce'][jdk_version]['checksum']
jce_cookie = node['java']['oracle']['accept_oracle_download_terms'] ? 'oraclelicense=accept-securebackup-cookie' : ''

directory ::File.join(node['java']['oracle']['jce']['home'], jdk_version) do
  mode '0755'
  recursive true
end

r = remote_file "#{Chef::Config[:file_cache_path]}/jce.zip" do
  source jce_url
  checksum jce_checksum
  headers(
    'Cookie' => jce_cookie
  )
  not_if { ::File.exist?(::File.join(node['java']['oracle']['jce']['home'], jdk_version, 'US_export_policy.jar')) }
end

if node['os'] == 'windows'
  include_recipe 'windows'

  staging_path = ::File.join(node['java']['oracle']['jce']['home'], jdk_version)
  staging_local_policy = ::File.join(staging_path, "UnlimitedJCEPolicyJDK#{jdk_version}", 'local_policy.jar')
  staging_export_policy = ::File.join(staging_path, "UnlimitedJCEPolicyJDK#{jdk_version}", 'US_export_policy.jar')
  jre_final_path = ::File.join(node['java']['java_home'], 'jre', 'lib', 'security')
  final_local_policy = ::File.join(jre_final_path, 'local_policy.jar')
  final_export_policy = ::File.join(jre_final_path, 'US_export_policy.jar')

  windows_zipfile staging_path do
    source r.path
    checksum jce_checksum
    action :unzip
    not_if { ::File.exist? staging_local_policy }
  end

  remote_file final_local_policy do
    rights :full_control, node['java']['windows']['owner']
    source "file://#{staging_local_policy}"
  end

  remote_file final_export_policy do
    rights :full_control, node['java']['windows']['owner']
    source "file://#{staging_export_policy}"
  end

else
  package 'unzip'
  package 'curl'

  execute 'extract jce' do
    command <<-EOF
      rm -rf java_jce
      mkdir java_jce
      cd java_jce
      unzip -o ../jce.zip
      find -name '*.jar' | xargs -I JCE_JAR mv JCE_JAR #{node['java']['oracle']['jce']['home']}/#{jdk_version}/
      chmod -R 0644 #{node['java']['oracle']['jce']['home']}/#{jdk_version}/*.jar
    EOF
    cwd Chef::Config[:file_cache_path]
    creates ::File.join(node['java']['oracle']['jce']['home'], jdk_version, 'US_export_policy.jar')
  end

  %w(local_policy.jar US_export_policy.jar).each do |jar|
    jar_path = ::File.join(node['java']['java_home'], 'jre', 'lib', 'security', jar)
    # remove the jars already in the directory
    file jar_path do
      action :delete
      not_if { ::File.symlink? jar_path }
    end
    link jar_path do
      to ::File.join(node['java']['oracle']['jce']['home'], jdk_version, jar)
    end
  end
end

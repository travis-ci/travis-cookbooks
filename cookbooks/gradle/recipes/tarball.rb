# Cookbook Name:: gradle
# Recipe:: tarball
#
# Copyright 2012, Michael S. Klishin.
# Copyright 2013-2015, Travis CI GmbH
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

include_recipe 'travis_java'

package %w(
  groovy
  unzip
)

zip_dest = File.join(
  Chef::Config[:file_cache_path],
  "gradle-#{node['gradle']['version']}-bin.zip"
)

unzipped_dir = File.join(
  Chef::Config[:file_cache_path],
  "gradle-#{node['gradle']['version']}"
)

remote_file zip_dest do
  source node['gradle']['tarball']['url']

  not_if do
    File.exist?("#{node['gradle']['installation_dir']}/bin/gradle")
  end
end

bash "extract #{zip_dest} to #{node['gradle']['installation_dir']}" do
  user 'root'
  cwd '/tmp'

  code <<-EOS
    unzip #{zip_dest}
    rm -rf #{node['gradle']['installation_dir']}
    mv --force #{unzipped_dir} #{node['gradle']['installation_dir']}
  EOS

  creates "#{node['gradle']['installation_dir']}/bin/gradle"
end

cookbook_file '/etc/profile.d/gradle.sh' do
  source 'etc/profile.d/gradle.sh'
  owner 'root'
  group 'root'
  mode 0644
end

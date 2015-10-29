#
# Cookbook Name:: travis_java
# Recipe:: oraclejdk9
#
# Copyright 2012-2105, Michael S. Klishin & Travis CI Development Team
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

include_recipe 'travis_java::webupd8'

# accept Oracle License v1.1, otherwise the package won't install
bash 'accept oracle license v1.1' do
  code <<-EOBASH.gsub(/^\s+>\s/, '')
    > /bin/echo -e oracle-java9-installer shared/accepted-oracle-license-v1-1 select true | \\
    >   debconf-set-selections
  EOBASH
end

installer = File.join(Chef::Config[:file_cache_path], 'oracle-java9-installer.deb')

remote_file installer do
  source "http://ppa.launchpad.net/webupd8team/java/ubuntu/pool/main/o/oracle-java9-installer/oracle-java9-installer_#{node['travis_java']['oraclejdk9']['pinned_release']}.deb"
  not_if "test -f #{installer}"
  only_if { node['travis_java']['oraclejdk9']['pinned_release'] }
end

dpkg_package installer do
  action :install
  only_if { node['travis_java']['oraclejdk9']['pinned_release'] }
end

package 'oracle-java9-installer' do
  not_if { node['travis_java']['oraclejdk9']['pinned_release'] }
end

oraclejdk9_home = File.join(
  node['travis_java']['jvm_base_dir'],
  node['travis_java']['oraclejdk9']['jvm_name']
)

# FIXME: at the moment, the 'jre' subdirectory doesn't exist in Oracle JDK 9-EA package...
# link "#{oraclejdk9_home}/jre/lib/security/cacerts" do
#   to '/etc/ssl/certs/java/cacerts'
# end

package 'oracle-java9-unlimited-jce-policy'

directory '/var/cache/oracle-jdk9-installer' do
  action :delete
  recursive true
  ignore_failure true
end

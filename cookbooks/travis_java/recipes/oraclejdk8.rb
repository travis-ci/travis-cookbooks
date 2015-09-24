#
# Cookbook Name:: travis_java
# Recipe:: oraclejdk8
#
# Copyright 2012, Michael S. Klishin & Travis CI Development Team
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

include_recipe 'java::webupd8'

# accept Oracle License v1.1, otherwise the package won't install
bash 'accept oracle license v1.1' do
  code <<-EOBASH.gsub(/^\s+>\s/, '')
    > /bin/echo -e oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | \\
    >   debconf-set-selections
  EOBASH
end

installer = File.join(Chef::Config[:file_cache_path], 'oracle-java8-installer.deb')

remote_file installer do
  source "http://ppa.launchpad.net/webupd8team/java/ubuntu/pool/main/o/oracle-java8-installer/oracle-java8-installer_#{node['travis_java']['oraclejdk8']['pinned_release']}.deb"
  not_if "test -f #{installer}"
  only_if { node['travis_java']['oraclejdk8']['pinned_release'] }
end

dpkg_package installer do
  action :install
  only_if { node['travis_java']['oraclejdk8']['pinned_release'] }
end

package 'oracle-java8-installer' do
  not_if { node['travis_java']['oraclejdk8']['pinned_release'] }
end

oraclejdk8_home = File.join(
  node['travis_java']['jvm_base_dir'],
  node['travis_java']['oraclejdk8']['jvm_name']
)

link "#{oraclejdk8_home}/jre/lib/security/cacerts" do
  to '/etc/ssl/certs/java/cacerts'
end

directory '/var/cache/oracle-jdk8-installer' do
  action :delete
  recursive true
  ignore_failure true
end

bash 'install jce unlimited' do
  code <<-EOBASH.gsub(/^\s+>\s/, '')
    > curl -L --cookie 'oraclelicense=accept-securebackup-cookie;' \\
    >   -o /tmp/policy.zip  \\
    >   http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip && \\
    > sudo unzip -j -o /tmp/policy.zip *.jar -d #{oraclejdk8_home}/jre/lib/security && \\
    > rm /tmp/policy.zip
  EOBASH
  only_if { node['travis_java']['oraclejdk8']['install_jce_unlimited'] }
end

#
# Cookbook Name:: java
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

node['java']['java_home'] = node.java.oraclejdk8.java_home

# This recipe relies on a PPA package and is Ubuntu/Debian specific. Please
# keep this in mind.

package "debconf-utils"

# accept Oracle License v1.1, otherwise the package won't install
execute "/bin/echo -e oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections"

apt_repository "webupd8team-java-ppa" do
  uri          "http://ppa.launchpad.net/webupd8team/java/ubuntu"
  distribution node['lsb']['codename']
  components   ["main"]
  key          "EEA14886"
  keyserver    "keyserver.ubuntu.com"

  action :add
end

require "tmpdir"

ca_installer_location = File.join(Dir.tmpdir, "install_startssl_certificates.sh")

cookbook_file(ca_installer_location) do
  source "startssl_root_ca_installer.sh"
  owner  "root"
  mode   0755
end

execute "install StarSSL CA certificate for Oracle JDK 8" do
  user    "root"
  command "/bin/sh #{ca_installer_location} && rm #{ca_installer_location}"

  timeout 15
  action  :nothing
  
  environment  Hash["JAVA_HOME" => node.java.oraclejdk8.java_home]
end

package "oracle-java8-installer" do
  action :install

  notifies :run, resources(:execute => "install StarSSL CA certificate for Oracle JDK 8")
end


cookbook_file "/usr/lib/jvm/.java-8-oracle.jinfo" do
  source "oraclejdk8.jinfo"
  owner "root"
  mode 0644
end

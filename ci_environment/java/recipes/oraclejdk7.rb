#
# Cookbook Name:: java
# Recipe:: oracle
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

node['java']['java_home'] = node.java.oraclejdk7.java_home

# This recipe relies on a PPA package and is Ubuntu/Debian specific. Please
# keep this in mind.

apt_repository "webupd8team-java-ppa" do
  uri          "http://ppa.launchpad.net/webupd8team/java/ubuntu"
  distribution node['lsb']['codename']
  components   ["main"]
  key          "EEA14886"
  keyserver    "keyserver.ubuntu.com"

  action :add
end

require "tmpdir"

# running this installer is necessary because Leiningen 2 Preview 5 uses HTTPS for all requests to clojars.org.
# clojars.org, in turn, happens to use a TLS certificate from StartSSL which is not included into the default
# keychain for Oracle JDK 7. Which means, all Clojure projects on travis will blow up as soon as they try to
# install dependencies.
#
# Regardless of how this plays out for Leiningen, we need to make sure Travis users don't have
# to suffer from this. MK.
ca_installer_location = File.join(Dir.tmpdir, "install_startssl_certificates.sh")

cookbook_file(ca_installer_location) do
  source "startssl_root_ca_installer.sh"
  owner  "root"
  mode   0755
end

execute "install StarSSL CA certificate for Oracle JDK 7" do
  user    "root"
  command "/bin/sh #{ca_installer_location} && rm #{ca_installer_location}"

  timeout 15
  action  :nothing
  
  environment  Hash["JAVA_HOME" => node.java.oraclejdk7.java_home]
end

package "oracle-java7-installer" do
  action :install

  notifies :run, resources(:execute => "install StarSSL CA certificate for Oracle JDK 7")
end


cookbook_file "/usr/lib/jvm/.java-7-oracle.jinfo" do
  source "oraclejdk7.jinfo"
  owner "root"
  mode 0644
end

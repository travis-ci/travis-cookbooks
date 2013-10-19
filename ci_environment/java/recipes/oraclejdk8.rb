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

include_recipe 'java::webupd8'


# accept Oracle License v1.1, otherwise the package won't install
execute "/bin/echo -e oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections"

package "oracle-java8-installer"

oraclejdk8_home = File.join(node['java']['jvm_base_dir'], node['java']['oraclejdk8']['jvm_name'])

link "#{oraclejdk8_home}/jre/lib/security/cacerts" do
  to '/etc/ssl/certs/java/cacerts'
end

# Note about JCE unlimited: There is currently no JCE Unlimited Strength package for JDK8, as it still in 'Developer Preview' phase.
# Projects interested in Java8-EA integrate should thus be aware of this current limitation...
#
# See also:
# - https://www.java.net//forum/topic/jdk/java-se-snapshots-project-feedback/jdk-8-missing-jce
# - http://openjdk.java.net/projects/jdk8/
#
# if node.java.oraclejdk8.install_jce_unlimited
#   execute "curl -L ..."
# end

#
# Cookbook Name:: java
# Recipe:: oraclejdk7
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
execute "/bin/echo -e oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections"

package "oracle-java7-installer"

oraclejdk7_home = File.join(node['java']['jvm_base_dir'], node['java']['oraclejdk7']['jvm_name'])

link "#{oraclejdk7_home}/jre/lib/security/cacerts" do
  to '/etc/ssl/certs/java/cacerts'
end

if node.java.oraclejdk7.install_jce_unlimited
  execute "curl -L --cookie 'ARU_LANG=US; s_cc=true; gpw_e24=http%3A%2F%2Fwww.oracle.com%2Ftechnetwork%2Fjava%2Fjavase%2Fdownloads%2Fjce-6-download-429243.html; s_sq=oracleotnlive%2Coracleglobal%3D%2526pid%253Dotn%25253Aen-us%25253A%25252Fjava%25252Fjavase%25252Fdownloads%25252Fjce-6-download-429243.html%2526pidt%253D1%2526oid%253Dhttp%25253A%25252F%25252Fwww.oracle.com%25252Ftechnetwork%25252Fjava%25252Fjavase%25252Fdownloads%25252Fjce-6-download-429243.html%2526ot%253DA'  http://download.oracle.com/otn-pub/java/jce/7/UnlimitedJCEPolicyJDK7.zip -o /tmp/policy.zip && sudo unzip -j -o /tmp/policy.zip *.jar -d #{oraclejdk7_home}/jre/lib/security && rm /tmp/policy.zip"
end

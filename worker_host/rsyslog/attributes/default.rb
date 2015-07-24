#
# Cookbook Name:: rsyslog
# Attributes:: rsyslog
#
# Copyright 2009, Opscode, Inc.
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

default["rsyslog"]["log_dir"]       = "/srv/rsyslog"
default["rsyslog"]["server"]        = false
default["rsyslog"]["protocol"]      = "tcp"
default["rsyslog"]["port"]          = "514"
default["rsyslog"]["server_ip"]     = nil
default["rsyslog"]["server_search"] = "role:loghost"
default["rsyslog"]["remote_logs"]   = true
default["rsyslog"]["per_host_dir"]  = "%$YEAR%/%$MONTH%/%$DAY%/%HOSTNAME%"

case node["platform"]
when "debian"
  default["rsyslog"]["user"] = "root"
  default["rsyslog"]["group"] = "adm"
  default["rsyslog"]["priv_seperation"] = false
when "ubuntu"
  # syslog user introduced with natty package
  if  node['platform_version'].to_f >= 10.10 then
    default["rsyslog"]["user"] = "root"
    default["rsyslog"]["group"] = "adm"
    default["rsyslog"]["priv_seperation"] = false
  else
    default["rsyslog"]["user"] = "syslog"
    default["rsyslog"]["group"] = "adm"
    default["rsyslog"]["priv_seperation"] = true
  end
else
  #values for fedora at least
  default["rsyslog"]["user"] = "root"
  default["rsyslog"]["group"] = "root"
  default["rsyslog"]["priv_seperation"] = false
end

default["rsyslog"]["max_message_size"] = "2k"

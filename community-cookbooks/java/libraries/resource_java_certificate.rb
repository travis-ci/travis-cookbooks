#
# Author:: Mevan Samaratunga (<mevansam@gmail.com>)
# Author:: Michael Goetz (<mpgoetz@gmail.com>)
# Cookbook:: java-libraries
# Resource:: certificate
#
# Copyright:: 2013, Mevan Samaratunga
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

class Chef::Resource::JavaCertificate < Chef::Resource::LWRPBase
  self.resource_name = 'java_certificate'

  actions :install, :remove
  default_action :install

  attribute :java_home, kind_of: String, default: nil

  attribute :keystore_path, kind_of: String, default: nil
  attribute :keystore_passwd, kind_of: String, default: nil

  attribute :cert_alias, kind_of: String, default: nil
  attribute :cert_data, kind_of: String, default: nil
  attribute :cert_file, kind_of: String, default: nil
  attribute :ssl_endpoint, kind_of: String, default: nil
end

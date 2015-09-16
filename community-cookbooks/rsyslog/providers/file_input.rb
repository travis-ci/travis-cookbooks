# Cookbook Name:: rsyslog
# Provider:: file_input
#
# Copyright 2012, Joseph Holsten
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

use_inline_resources

include RsyslogCookbook::Helpers

action :create do
  declare_rsyslog_service

  template "/etc/rsyslog.d/#{new_resource.priority}-#{new_resource.name}.conf" do
    mode '0664'
    owner node['rsyslog']['user']
    group node['rsyslog']['group']
    source new_resource.source
    cookbook new_resource.cookbook
    variables 'file_name' => new_resource.file,
              'tag' => new_resource.name,
              'state_file' => new_resource.name,
              'severity' => new_resource.severity,
              'facility' => new_resource.facility
    notifies :restart, resources('service[rsyslog]')
  end
end

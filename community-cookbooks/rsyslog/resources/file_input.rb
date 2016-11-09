# Cookbook Name:: rsyslog
# Resource:: file_input
#
# Copyright 2012-2015, Joseph Holsten
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

actions :create

property :name, String, name_attribute: true, required: true
property :file, String, required: true
property :priority, Integer, default: 99
property :severity, String
property :facility, String
property :cookbook_source, String, default: 'rsyslog'
property :template_source, String, default: 'file-input.conf.erb'

action :create do
  log_name = name
  template "/etc/rsyslog.d/#{priority}-#{name}.conf" do
    mode '0664'
    owner node['rsyslog']['user']
    group node['rsyslog']['group']
    source template_source
    cookbook cookbook_source
    variables 'file_name' => file,
              'tag' => log_name,
              'state_file' => log_name,
              'severity' => severity,
              'facility' => facility
    notifies :restart, "service[#{node['rsyslog']['service_name']}]"
  end

  service node['rsyslog']['service_name'] do
    supports restart: true, status: true
    action [:enable, :start]
  end
end

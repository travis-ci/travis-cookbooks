#
# Cookbook Name:: iptables
# Provider:: rule
#
# Copyright 2008-2015, Chef Software, Inc.
# Copyright 2015, Tim Smith
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

def whyrun_supported?
  true
end

use_inline_resources

action :enable do
  execute 'rebuild-iptables' do
    command '/usr/sbin/rebuild-iptables'
    action :nothing
  end

  template "/etc/iptables.d/#{new_resource.name}" do
    source new_resource.source ? new_resource.source : "#{new_resource.name}.erb"
    mode '0644'
    cookbook new_resource.cookbook if new_resource.cookbook
    variables new_resource.variables
    backup false
    notifies :run, resources(:execute => 'rebuild-iptables')
  end
end

action :disable do
  execute 'rebuild-iptables' do
    command '/usr/sbin/rebuild-iptables'
    action :nothing
  end

  file "/etc/iptables.d/#{new_resource.name}" do
    action :delete
    backup false
    notifies :run, resources(:execute => 'rebuild-iptables')
  end
end

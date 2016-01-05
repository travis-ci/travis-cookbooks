#
# Cookbook Name:: rabbitmq
# Recipe:: default
#
# Copyright 2009, Benjamin Black
# Copyright 2009-2011, Opscode, Inc.
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

directory "/etc/rabbitmq/" do
  owner "root"
  group "root"
  mode 0755
  action :create
end

template "/etc/rabbitmq/rabbitmq-env.conf" do
  source "rabbitmq-env.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

template "/etc/rabbitmq/rabbitmq.config" do
  source "rabbitmq.config.erb"
  owner "root"
  group "root"
  mode 0644
end

rabbitmq_deb = ::File.join(
  Chef::Config[:file_cache_path],
  "rabbitmq-server_#{node['rabbitmq']['deb_version']}-1.all.deb"
)

remote_file rabbitmq_deb do
  source ::File.join(
    'https://www.rabbitmq.com/releases/rabbitmq-server',
    "v#{node['rabbitmq']['deb_version']}",
    ::File.basename(rabbitmq_deb)
  )
end

dpkg_package 'rabbitmq-server' do
  source rabbitmq_deb
end

service "rabbitmq-server" do
  supports :restart => true, :status => true, :reload => true

  if node.rabbitmq.service.enabled
    action [:enable, :stop]
  else
    action [:disable, :stop]
  end
end

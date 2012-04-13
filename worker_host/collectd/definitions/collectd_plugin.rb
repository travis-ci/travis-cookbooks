#
# Cookbook Name:: collectd
# Definition:: collectd_plugin
#
# Copyright 2010, Atari, Inc
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

define :collectd_plugin, :options => {}, :template => nil, :cookbook => nil do
  template "#{node[:collectd][:plugin_conf_dir]}/#{params[:name]}.conf" do
    owner "root"
    group "root"
    mode "644"
    if params[:template].nil?
      source "plugin.conf.erb"
      cookbook params[:cookbook] || "collectd"
    else
      source params[:template]
      cookbook params[:cookbook]
    end
    variables :name=>params[:name], :options=>params[:options]
    notifies :restart, resources(:service => "collectd")
  end
end

define :collectd_python_plugin, :options => {}, :module => nil, :path => nil do
  begin
    t = resources(:template => "#{node[:collectd][:plugin_conf_dir]}/python.conf")
  rescue ArgumentError, Chef::Exceptions::ResourceNotFound
    collectd_plugin "python" do
      options :paths=>[node[:collectd][:plugin_dir]], :modules=>{}
      template "python_plugin.conf.erb"
      cookbook "collectd"
    end
    retry
  end
  if params[:path]
    t.variables[:options][:paths] << params[:path]
  end
  t.variables[:options][:modules][params[:module] || params[:name]] = params[:options]
end

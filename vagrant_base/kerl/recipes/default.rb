#
# Cookbook Name:: kerl
# Recipe:: default
#
# Copyright 2011, Michael S. Klishin, Ward Bekker
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

case node['platform']
when "ubuntu","debian"
  %w{libreadline5-dev libncurses5-dev libssl-dev}.each do |pkg|
    package(pkg) { action :install }
  end # each
end # case

installation_root = "/home/#{node.kerl.user}/otp"

directory(installation_root) do
  owner node.kerl.user
  group node.kerl.group
  mode  "0755"
  action :create
end

remote_file(node.kerl.path) do
  source "https://raw.github.com/spawngrid/kerl/master/kerl"
  mode "0755"
end


home = "/home/#{node.kerl.user}"
env  = {
  'HOME'               => home,
  'USER'               => node.kerl.user,
  'KERL_DISABLE_AGNER' => 'yes',
  "KERL_BASE_DIR"      => "#{home}/.kerl"
}

execute "erlang.releases.update" do
  command "#{node.kerl.path} update releases"

  user    node.kerl.user
  group   node.kerl.group

  environment(env)

  # run when kerl script is downloaded & installed
  subscribes :run, resources(:remote_file => node.kerl.path)
end


node.kerl.releases.each do |rel, build|
  execute "build Erlang #{rel}" do
    command "#{node.kerl.path} build #{rel} #{rel}"

    user    node.kerl.user
    group   node.kerl.group

    environment(env)

    not_if "#{node.kerl.path} list builds | grep #{rel}", :user => node.kerl.user, :environment => env
  end


  execute "install Erlang #{rel}" do
    command "#{node.kerl.path} install #{rel} #{installation_root}/#{rel}"

    user    node.kerl.user
    group   node.kerl.group

    environment(env)

    not_if "#{node.kerl.path} list installations | grep #{rel}", :user => node.kerl.user, :environment => env
  end
end

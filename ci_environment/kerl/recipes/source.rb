#
# Cookbook Name:: kerl
# Recipe:: source
#
# Copyright 2011-2012, Michael S. Klishin, Ward Bekker
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

include_recipe "libreadline"
include_recipe "libssl"
include_recipe "libncurses"

package "curl" do
  action :install
end

installation_root = "/home/#{node.travis_build_environment.user}/otp"

directory(installation_root) do
  owner node.travis_build_environment.user
  group node.travis_build_environment.group
  mode  "0755"
  action :create
end

remote_file(node.kerl.path) do
  source "https://raw.github.com/spawngrid/kerl/master/kerl"
  mode "0755"
end


home = "/home/#{node.travis_build_environment.user}"
env  = {
  'HOME'               => home,
  'USER'               => node.travis_build_environment.user,
  'KERL_DISABLE_AGNER' => 'yes',
  "KERL_BASE_DIR"      => "#{home}/.kerl"
}

case [node[:platform], node[:platform_version]]
when ["ubuntu", "11.04"] then
    # fixes compilation with Ubuntu 11.04 zlib. MK.
  env["KERL_CONFIGURE_OPTIONS"] = "--enable-dynamic-ssl-lib --enable-hipe"
end

# updates list of available releases. Needed for kerl to recognize
# R15B, for example. MK.
execute "erlang.releases.update" do
  command "#{node.kerl.path} update releases"

  user    node.travis_build_environment.user
  group   node.travis_build_environment.group

  environment(env)

  # run when kerl script is downloaded & installed
  subscribes :run, resources(:remote_file => node.kerl.path)
end

cookbook_file "#{node.travis_build_environment.home}/.erlang.cookie" do
  owner node.travis_build_environment.user
  group node.travis_build_environment.group
  mode 0600

  source "erlang.cookie"
end

cookbook_file "#{node.travis_build_environment.home}/.build_plt" do
  owner node.travis_build_environment.user
  group node.travis_build_environment.group
  mode 0700

  source "build_plt"
end


node.kerl.releases.each do |rel, build|
  execute "build Erlang #{rel}" do
    command "#{node.kerl.path} build #{rel} #{rel}"

    user    node.travis_build_environment.user
    group   node.travis_build_environment.group

    environment(env)

    # make sure R14B02 won't cause R14B to be skipped. MK.
    not_if "#{node.kerl.path} list builds | grep \"#{rel}$\"", :user => node.travis_build_environment.user, :environment => env
  end


  execute "install Erlang #{rel}" do
    # cleanup is available starting with https://github.com/spawngrid/kerl/pull/28
    command "#{node.kerl.path} install #{rel} #{installation_root}/#{rel} && #{node.kerl.path} cleanup #{rel} && rm -rf #{node.travis_build_environment.home}/.kerl/archives/*" # && ~/.build_plt #{installation_root}/#{rel} #{installation_root}/#{rel}/lib"

    user    node.travis_build_environment.user
    group   node.travis_build_environment.group

    environment(env)

    not_if "#{node.kerl.path} list installations | grep #{rel}", :user => node.travis_build_environment.user, :environment => env
  end
end

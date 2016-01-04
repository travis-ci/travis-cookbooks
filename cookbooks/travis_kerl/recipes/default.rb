# Cookbook Name:: travis_kerl
# Recipe:: default
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

package %w(
  curl
  libncurses-dev
  libreadline-dev
  libssl-dev
  unixodbc-dev
)

installation_root = "/home/#{node['travis_build_environment']['user']}/otp"

directory installation_root do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0755
end

remote_file node['travis_kerl']['path'] do
  source 'https://raw.githubusercontent.com/spawngrid/kerl/master/kerl'
  mode 0755
end

base_dir = "#{node['travis_build_environment']['home']}/.kerl"
env = {
  'HOME' => node['travis_build_environment']['home'],
  'USER' => node['travis_build_environment']['user'],
  'KERL_DISABLE_AGNER' => 'yes',
  'KERL_BASE_DIR' => base_dir,
  'CPPFLAGS' => "#{ENV['CPPFLAGS']} -DEPMD6"
}

execute "#{node['travis_kerl']['path']} update releases" do
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  environment(env)
  subscribes :run, "remote_file[#{node['travis_kerl']['path']}]"
end

cookbook_file "#{node['travis_build_environment']['home']}/.erlang.cookie" do
  source 'erlang.cookie'
  mode 0600
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
end

cookbook_file "#{node['travis_build_environment']['home']}/.build_plt" do
  source 'build_plt'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0700
end

node['travis_kerl']['releases'].each do |rel|
  local_archive = ::File.join(Chef::Config[:file_cache_path], "erlang-#{rel}.tar.bz2")
  rel_dir = ::File.join(node['travis_build_environment']['home'], 'otp', rel)

  remote_file local_archive do
    source ::File.join(
      'https://s3.amazonaws.com/travis-otp-releases/binaries',
      node['platform'],
      node['platform_version'],
      node['kernel']['machine'],
      ::File.basename(local_archive)
    )
  end

  bash "Expand Erlang #{rel} archive" do
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']

    code <<-EOF
      tar -xjf #{local_archive} --directory #{::File.dirname(rel_dir)}
      echo #{rel} >> #{::File.join(base_dir, 'otp_installations')}
      echo #{rel},#{rel} >> #{::File.join(base_dir, 'otp_builds')}
    EOF

    not_if { ::File.exist?(rel_dir) }
  end
end

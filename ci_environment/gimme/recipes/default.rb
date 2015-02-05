#
# Cookbook Name:: gimme
# Recipe:: default
#
# Copyright 2015, Travis CI GmbH
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

include_recipe 'build-essential'

remote_file '/usr/local/bin/gimme' do
  source node['gimme']['url']
  checksum node['gimme']['sha256sum']
  owner 'root'
  group 'root'
  mode 0755
end

directory "#{node['gimme']['install_user_home']}/.gimme" do
  owner node['gimme']['install_user']
  group node['gimme']['install_user']
  mode 0750
end

file "#{node['gimme']['install_user_home']}/.gimme/version" do
  content "#{node['gimme']['default_version']}"
  owner node['gimme']['install_user']
  group node['gimme']['install_user']
  mode 0640
  not_if { node['gimme']['default_version'].empty? }
end

template '/etc/profile.d/Z90-gimme.sh' do
  source 'etc-profile-d-gimme.sh.erb'
  variables(default_version: node['gimme']['default_version'])
  owner 'root'
  group 'root'
  mode 0755
end

install_env = {
  'GIMME_ENV_PREFIX' => "#{node['gimme']['install_user_home']}/.gimme/envs",
  'GIMME_VERSION_PREFIX' => "#{node['gimme']['install_user_home']}/.gimme/versions",
  'HOME' => node['gimme']['install_user_home'],
}

install_env['GIMME_DEBUG'] = '1' if node['gimme']['debug']

node['gimme']['versions'].each do |version|
  log "running gimme install of #{version}" do
    level :info
  end

  execute "gimme_install_#{version}" do
    command 'gimme'
    environment(install_env.merge('GIMME_GO_VERSION' => version))
    user node['gimme']['install_user']
    group node['gimme']['install_user']
    umask 0077
  end
end

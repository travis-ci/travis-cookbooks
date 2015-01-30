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

remote_file '/usr/local/bin/gimme' do
  source node['gimme']['url']
  checksum node['gimme']['sha256sum']
  owner 'root'
  group 'root'
  mode '0755'
end

node['gimme']['versions'].each do |version|
  log "running gimme install of #{version}" do
    level :info
  end

  execute "gimme_install_#{version}" do
    command 'gimme'
    environment(
      'GIMME_GO_VERSION' => version,
      'GIMME_VERSION_PREFIX' => "#{node['gimme']['install_user_home']}/.gimme/versions",
      'GIMME_ENV_PREFIX' => "#{node['gimme']['install_user_home']}/.gimme/envs",
      'HOME' => node['gimme']['install_user_home'],
    )
    user node['gimme']['install_user']
  end
end

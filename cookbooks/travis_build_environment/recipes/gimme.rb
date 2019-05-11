# frozen_string_literal: true

# Cookbook Name:: travis_build_environment
# Recipe:: gimme
#
# Copyright 2017 Travis CI GmbH
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

def obtain_gimme_url
  http = Net::HTTP.new('api.github.com', 443)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  request = Net::HTTP::Get.new('/repos/travis-ci/gimme/releases/latest')
  request['Accept'] = 'application/json'
  token = node&.[]('travis_packer_build')&.[]('github_token')
  request['Authorization'] = "token #{token}" if token
  response = http.request(request)
  tag = JSON.parse(response.body).fetch('tag_name')
  "https://raw.githubusercontent.com/travis-ci/gimme/#{tag}/gimme"
end

gimme_url = obtain_gimme_url

remote_file '/usr/local/bin/gimme' do
  source gimme_url
  owner 'root'
  group 'root'
  mode 0o755
end

directory "#{node['travis_build_environment']['home']}/.gimme" do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o750
end

file "#{node['travis_build_environment']['home']}/.gimme/version" do
  content node['travis_build_environment']['gimme']['default_version']
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o640
  not_if { node['travis_build_environment']['gimme']['default_version'].empty? }
end

template '/etc/profile.d/Z90-gimme.sh' do
  source 'etc-profile-d-gimme.sh.erb'
  variables(
    default_version: node['travis_build_environment']['gimme']['default_version']
  )
  owner 'root'
  group 'root'
  mode 0o755
end

gimme_default_version = node['travis_build_environment']['gimme']['default_version'].to_s
gimme_versions = Array(node['travis_build_environment']['gimme']['versions'])
gimme_versions += [gimme_default_version] unless gimme_default_version.empty?

default_env = {
  'GOPATH' => "#{node['travis_build_environment']['home']}/gopath",
  'HOME' => node['travis_build_environment']['home']
}

install_env = default_env.merge(
  'GIMME_ENV_PREFIX' => "#{node['travis_build_environment']['home']}/.gimme/envs",
  'GIMME_VERSION_PREFIX' => "#{node['travis_build_environment']['home']}/.gimme/versions"
)

install_env['GIMME_DEBUG'] = '1' if node['travis_build_environment']['gimme']['debug']

gimme_versions.each do |version|
  version = version.delete('go')

  log "running gimme install of #{version}" do
    level :info
  end

  execute "gimme install #{version}" do
    command 'gimme'
    environment(install_env.merge('GIMME_GO_VERSION' => version))
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    umask 0o077
  end
end

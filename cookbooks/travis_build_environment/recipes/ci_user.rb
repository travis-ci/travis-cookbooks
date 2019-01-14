# frozen_string_literal: true

# Cookbook Name:: travis_build_environment
# Recipe:: ci_user
# Copyright 2018 Travis CI GmbH
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'json'
require 'net/http'
require 'openssl'
require 'pathname'

def obtain_nvm_url
  http = Net::HTTP.new('api.github.com', 443)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  request = Net::HTTP::Get.new('/repos/creationix/nvm/releases/latest')
  request['Accept'] = 'application/json'
  token = node&.[]('travis_packer_build')&.[]('github_token')
  request['Authorization'] = "token #{token}" if token
  response = http.request(request)
  tag = JSON.parse(response.body).fetch('tag_name')
  "https://raw.githubusercontent.com/creationix/nvm/#{tag}/nvm.sh"
end

home = Pathname.new(node['travis_build_environment']['home'])

user node['travis_build_environment']['user'] do
  comment node['travis_build_environment']['user_comment']
  shell '/bin/bash'
  manage_home true
end

group node['travis_build_environment']['group'] do
  members [node['travis_build_environment']['user']]
end

[
  { name: home },
  { name: home.join('.m2') },
  { name: home.join('.ssh') },
  { name: home.join('bin'), perms: 0o755 },
  { name: home.join('builds'), perms: 0o755 },
  { name: home.join('gopath') },
  { name: home.join('gopath/bin') }
].each do |entry|
  directory entry[:name].to_s do
    owner node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    mode(entry[:perms] || 0o750)
  end
end

include_recipe 'travis_build_environment::bash_profile_d'

[
  { src: 'dot_bashrc.sh.erb', dest: '.bashrc', mode: 0o640 },
  { src: 'dot_bash_profile.sh.erb', dest: '.bash_profile', mode: 0o640 },
  { src: 'dot_gitconfig.erb', dest: '.gitconfig', mode: 0o640 }
].each do |entry|
  template "#{node['travis_build_environment']['home']}/#{entry[:dest]}" do
    source "ci_user/#{entry[:src]}"
    owner node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    mode(entry[:mode] || 0o640)
  end
end

file "#{node['travis_build_environment']['home']}/.travis_ci_environment.yml" do
  content YAML.dump(
    timestamp: Time.now.to_i,
    recipes: node.select_run_list.map(&:to_s)
  ) + "\n"
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o640
end

[
  { src: 'dot_gemrc.yml', dest: '.gemrc', mode: 0o640 },
  { src: 'dot_erlang_dot_cookie', dest: '.erlang.cookie' },
  { src: 'known_hosts', dest: '.ssh/known_hosts', mode: 0o600 },
  { src: 'maven_user_settings.xml', dest: '.m2/settings.xml', mode: 0o640 }
].each do |entry|
  cookbook_file "#{node['travis_build_environment']['home']}/#{entry[:dest]}" do
    source "ci_user/#{entry[:src]}"
    owner node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    mode(entry[:mode] || 0o400)
  end
end

mount "#{node['travis_build_environment']['home']}/builds" do
  fstype 'tmpfs'
  device '/dev/null'
  options "defaults,size=#{node['travis_build_environment']['builds_volume_size']},noatime"
  action %i[mount enable]
  only_if { node['travis_build_environment']['use_tmpfs_for_builds'] }
end

link '/home/vagrant' do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  to node['travis_build_environment']['home']
  not_if { File.exist?('/home/vagrant') }
end

unless Array(node['travis_build_environment']['otp_releases']).empty?
  include_recipe 'travis_build_environment::kerl'
end

Array(node['travis_build_environment']['otp_releases']).each do |rel|
  local_archive = ::File.join(
    Chef::Config[:file_cache_path],
    "erlang-#{rel}-nonroot.tar.bz2"
  )
  rel_dir = ::File.join(
    node['travis_build_environment']['home'], 'otp', rel
  )

  remote_file local_archive do
    source ::File.join(
      'https://s3.amazonaws.com/travis-otp-releases/binaries',
      node['platform'],
      node['platform_version'],
      node['kernel']['machine'],
      ::File.basename(local_archive)
    )
    retries 2
    retry_delay 10
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']

    ignore_failure true
  end

  bash "expand erlang #{rel} archive" do
    code <<-EOF.gsub(/^\s+>\s/, '')
      > tar -xjf #{local_archive} --directory #{::File.dirname(rel_dir)}
      > echo #{rel} >> #{::File.join(node['travis_build_environment']['kerl_base_dir'], 'otp_installations')}
      > echo #{rel},#{rel} >> #{::File.join(node['travis_build_environment']['kerl_base_dir'], 'otp_builds')}
    EOF

    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']

    not_if { ::File.exist?(rel_dir) }
    only_if { ::File.exist?(local_archive) }
  end

  kerl_build_cmd = "#{node['travis_build_environment']['kerl_path']} build #{rel} #{rel}"
  if node['kernel']['machine'] == 'ppc64le'
    kerl_build_cmd = "KERL_CONFIGURE_OPTIONS=--disable-hipe #{node['travis_build_environment']['kerl_path']} build #{rel} #{rel}"
  end

  bash "build erlang #{rel}" do
    code kerl_build_cmd

    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']

    environment(
      'HOME' => node['travis_build_environment']['home'],
      'USER' => node['travis_build_environment']['user']
    )

    not_if { ::File.exist?("#{rel_dir}/activate") }
  end

  bash "install erlang #{rel}" do
    flags '-e'
    code <<-EOF.gsub(/^\s+>\s/, '')
      > #{node['travis_build_environment']['kerl_path']} install #{rel} #{rel_dir}
      > #{node['travis_build_environment']['kerl_path']} cleanup #{rel}
      > rm -rf #{node['travis_build_environment']['home']}/.kerl/archives/*
    EOF

    environment(
      'HOME' => node['travis_build_environment']['home'],
      'USER' => node['travis_build_environment']['user']
    )

    not_if { ::File.exist?("#{rel_dir}/activate") }
  end
end

unless Array(node['travis_build_environment']['otp_releases']).empty?
  include_recipe 'travis_build_environment::rebar'
  include_recipe 'travis_build_environment::kiex'
end

Array(node['travis_build_environment']['elixir_versions']).each do |elixir|
  local_archive = "#{Chef::Config[:file_cache_path]}/v#{elixir}.zip"
  dest = "#{node['travis_build_environment']['home']}/.kiex/elixirs/elixir-#{elixir}"

  remote_file local_archive do
    source "https://github.com/elixir-lang/elixir/releases/download/v#{elixir}/Precompiled.zip"
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    mode 0o644
    retries 2
    retry_delay 10
  end

  bash "unpack #{local_archive}" do
    code "unzip -d #{dest} #{local_archive}"
    cwd node['travis_build_environment']['home']
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    environment(
      'HOME' => node['travis_build_environment']['home'],
      'USER' => node['travis_build_environment']['user']
    )
    creates "#{dest}/bin/elixirc"
  end

  file "#{node['travis_build_environment']['home']}/.kiex/elixirs/elixir-#{elixir}.env" do
    content <<-EOF.gsub(/^.*> /, '')
      > export ELIXIR_VERSION=#{elixir}
      > export PATH=#{node['travis_build_environment']['home']}/.kiex/elixirs/elixir-#{elixir}/bin:$PATH
      > export MIX_ARCHIVES=#{node['travis_build_environment']['home']}/.kiex/mix/elixir-#{elixir}
    EOF
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    mode 0o644
  end
end

bash "set default elixir version to #{node['travis_build_environment']['default_elixir_version'].inspect}" do
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  code "#{node['travis_build_environment']['home']}/.kiex/bin/kiex default #{node['travis_build_environment']['default_elixir_version']}"
  environment(
    'HOME' => node['travis_build_environment']['home'],
    'USER' => node['travis_build_environment']['user']
  )
  not_if { node['travis_build_environment']['default_elixir_version'].empty? }
end

unless Array(node['travis_build_environment']['php_packages']).empty?
  package Array(node['travis_build_environment']['php_packages'])
end

unless Array(node['travis_build_environment']['php_versions']).empty?
  include_recipe 'travis_phpenv'
end

phpenv_path = "#{node['travis_build_environment']['home']}/.phpenv"

Array(node['travis_build_environment']['php_versions']).each do |php_version|
  local_archive = ::File.join(
    Chef::Config[:file_cache_path],
    "php-#{php_version}.tar.bz2"
  )

  remote_file local_archive do
    source ::File.join(
      'https://s3.amazonaws.com/travis-php-archives/binaries',
      node['platform'],
      node['platform_version'],
      node['kernel']['machine'],
      ::File.basename(local_archive)
    )
    retries 2
    retry_delay 10
    not_if { ::File.exist?(local_archive) }
  end

  bash "Expand PHP #{php_version} archive" do
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    code "tar -xjf #{local_archive.inspect} --directory /"
  end

  link "#{phpenv_path}/versions/#{php_version}/bin/php-fpm" do
    to "#{phpenv_path}/versions/#{php_version}/sbin/php-fpm"
    not_if do
      ::File.exist?("#{phpenv_path}/versions/#{php_version}/sbin/php-fpm")
    end
  end
end

node['travis_build_environment']['php_aliases'].each do |short_version, target_version|
  link "#{phpenv_path}/versions/#{short_version}" do
    to "#{phpenv_path}/versions/#{target_version}"
    not_if do
      Array(node['travis_build_environment']['php_versions']).empty? ||
        ::File.exist?("#{phpenv_path}/versions/#{target_version}")
    end
  end
end

include_recipe 'travis_build_environment::hhvm'

bash 'set global default php' do
  # NOTE: It is important that this happens *after* the conditional inclusion of
  # the travis_build_environment::hhvm recipe just above so that the default php
  # version is not hhvm.
  code "phpenv global #{node['travis_build_environment']['php_default_version']}"
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  flags '-l'
  environment('HOME' => node['travis_build_environment']['home'])
  not_if { Array(node['travis_build_environment']['php_versions']).empty? }
end

bash 'remove ~travis/.pearrc' do
  code "rm -f #{node['travis_build_environment']['home']}/.pearrc"
  action :nothing
end

log 'trigger ~travis/.pearrc removal' do
  notifies :run, 'bash[remove ~travis/.pearrc]'
end

nvm_sh = ::File.join(node['travis_build_environment']['home'], '.nvm', 'nvm.sh')

directory ::File.dirname(nvm_sh) do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['user']
  mode 0o750
end

nvm_url = obtain_nvm_url

remote_file nvm_sh do
  source nvm_url
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['user']
  mode 0o750
end

template home.join('.bash_profile.d/nvm.bash') do
  source 'ci_user/bash_profile.d-nvm.bash.erb'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['user']
  mode 0o644
  variables(nvm_dir: home.join('.nvm'))
end

Array(node['travis_build_environment']['nodejs_versions']).each do |version|
  bash "installing node version #{version}" do
    code "source #{nvm_sh}; nvm install v#{version}"
    creates "#{node['travis_build_environment']['home']}/.nvm/v#{version}"
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    cwd node['travis_build_environment']['home']
    environment(
      'HOME' => node['travis_build_environment']['home']
    )
  end

  node['travis_build_environment']['nodejs_default_modules'].each do |mod|
    bash "install #{mod} for node version #{version}" do
      code "source #{nvm_sh}; nvm use #{version}; npm install -g #{mod}"
      creates "#{node['travis_build_environment']['home']}/.nvm/#{version}/lib/node_modules/#{mod}"
      user node['travis_build_environment']['user']
      group node['travis_build_environment']['group']
      cwd node['travis_build_environment']['home']
      environment('HOME' => node['travis_build_environment']['home'])
    end
  end
end

bash 'alias default node' do
  code "source #{nvm_sh}; nvm alias default v#{node['travis_build_environment']['nodejs_default']}"
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  not_if { node['travis_build_environment']['nodejs_default'].to_s.empty? }
end

Array(node['travis_build_environment']['nodejs_aliases']).each do |existing_name, new_name|
  bash "alias node #{existing_name} => #{new_name}" do
    code "source #{nvm_sh}; nvm alias #{new_name} v#{existing_name}"
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    cwd node['travis_build_environment']['home']
    environment('HOME' => node['travis_build_environment']['home'])
  end
end

bash 'clean up nvm build artifacts & sources' do
  code "rm -rf #{node['travis_build_environment']['home']}/.nvm/src"
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
end

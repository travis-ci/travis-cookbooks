#
# Cookbook Name:: travis_kiex
# Recipe:: default
#
# Copyright 2014-2015, Travis CI GmbH
#

include_recipe 'travis_kerl::binary'

env = {
  'HOME' => node['travis_build_environment']['home'],
  'USER' => node['travis_build_environment']['user']
}

bash 'install kiex' do
  code '\curl -sSL https://raw.githubusercontent.com/taylor/kiex/master/install | bash -s'
  user node['travis_build_environment']['user']
  cwd node['travis_build_environment']['home']
  group node['travis_build_environment']['group']
  creates "#{node['travis_build_environment']['home']}/.kiex/bin/kiex"
  environment(env)
end

cookbook_file 'kiex.sh' do
  path '/etc/profile.d/kiex.sh'
end

node['travis_kiex']['elixir_versions'].each do |elixir, _|
  bash "install elixir version #{elixir} with kiex" do
    user node['travis_build_environment']['user']
    cwd node['travis_build_environment']['home']
    group node['travis_build_environment']['group']
    code <<-EOF
      source #{node['travis_build_environment']['home']}/otp/#{node['travis_kiex']['required_otp_release_for'][elixir]}/activate
      #{node['travis_build_environment']['home']}/.kiex/bin/kiex install #{elixir}
    EOF
    environment(env)
  end
end

bash "set default elixir version to #{node['travis_kiex']['default_elixir_version']}" do
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  code "#{node['travis_build_environment']['home']}/.kiex/bin/kiex default #{node['travis_kiex']['default_elixir_version']}"
  environment(env)
end

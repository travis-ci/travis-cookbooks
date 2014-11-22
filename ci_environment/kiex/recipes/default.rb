#
# Cookbook Name:: kiex
# Recipe:: default
#
# Copyright 2014, Travis CI GmbH
#

include_recipe 'kerl'

bash 'install kiex' do
  code '\curl -sSL https://raw.githubusercontent.com/taylor/kiex/master/install | bash -s'
  user node.travis_build_environment.user
  cwd  node.travis_build_environment.home
  group node.travis_build_environment.group
  creates "#{ENV['HOME']}/.kiex/bin/kiex"
end

cookbook_file 'kiex.sh' do
  path '/etc/profile.d/kiex.sh'
end

node.kiex.elixir_versions.each do |elixir, otp|
  bash "install elixir version #{elixir} with kiex" do
    user node.travis_build_environment.user
    group node.travis_build_environment.group
    cwd node.travis_build_environment.home
    code <<-EOF
      source #{ENV['HOME']}/otp/#{node.kiex.required_otp_release_for[elixir]}/activate
      #{ENV['HOME']}/.kiex/bin/kiex install #{elixir}
    EOF
  end
end

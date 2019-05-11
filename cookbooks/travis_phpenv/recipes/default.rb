# frozen_string_literal: true

unless Array(node['travis_phpenv']['prerequisite_recipes']).empty?
  Array(node['travis_phpenv']['prerequisite_recipes']).each do |recipe_name|
    include_recipe recipe_name
  end
end

phpenv_clone = '/tmp/phpenv'
phpenv_path = "#{node['travis_build_environment']['home']}/.phpenv"

git phpenv_clone do
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  repository node['travis_phpenv']['git']['repository']
  revision node['travis_phpenv']['git']['revision']
  action :sync
end

bash 'install phpenv' do
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  cwd phpenv_clone
  code <<-PHPENV_INSTALL
    . bin/phpenv-install.sh
    cp extensions/rbenv-config-add #{phpenv_path}/libexec/
    cp extensions/rbenv-config-rm #{phpenv_path}/libexec/
  PHPENV_INSTALL
  environment(
    'PHPENV_ROOT' => phpenv_path
  )
  not_if { File.exist?("#{phpenv_path}/bin/phpenv") }
end

directory "#{phpenv_path}/versions" do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o755
  action :create
end

include_recipe 'travis_build_environment::bash_profile_d'

template ::File.join(
  node['travis_build_environment']['home'],
  '.bash_profile.d/phpenv.bash'
) do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  source 'phpenv.bash.erb'
  variables(phpenv_path: phpenv_path)
  mode 0o644
end

# A couple fixes for building php 5.3.29c and 5.4.45

package 'Install system dependencies' do
  package_name %w[libxslt1-dev libc-client2007e libmcrypt4]
  action :install
end

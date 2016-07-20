apt_repository 'hhvm-repository' do
  uri 'http://dl.hhvm.com/ubuntu'
  distribution node['lsb']['codename']
  components ['main']
  key 'http://dl.hhvm.com/conf/hhvm.gpg.key'
end

package node['travis_build_environment']['hhvm_package_name'] do
  options '--force-yes'
  action :install
end

include_recipe 'travis_phpenv'

phpenv_path = "#{node['travis_build_environment']['home']}/.phpenv"
hhvm_path = "#{phpenv_path}/versions/hhvm-stable"

directory hhvm_path do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  action :create
end

directory "#{hhvm_path}/bin" do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  action :create
end

link "#{hhvm_path}/bin/php" do
  to '/usr/bin/hhvm'
end

link "#{phpenv_path}/versions/hhvm" do
  to hhvm_path
end

remote_file "#{hhvm_path}/bin/composer" do
  source 'http://getcomposer.org/composer.phar'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0755
end

remote_file "#{hhvm_path}/bin/phpunit" do
  source 'https://phar.phpunit.de/phpunit.phar'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0755
end

directory "#{phpenv_path}/rbenv.d/exec" do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  recursive true
end

template "#{phpenv_path}/rbenv.d/exec/hhvm-switcher.bash" do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  source 'hhvm-switcher.bash.erb'
  variables(
    phpenv_path: phpenv_path
  )
end

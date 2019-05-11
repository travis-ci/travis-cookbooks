# frozen_string_literal: true

apt_repository 'hhvm-repository' do
  uri 'https://dl.hhvm.com/ubuntu'
  distribution node['lsb']['codename']
  components ['main']
  arch 'amd64'
  keyserver 'keyserver.ubuntu.com'
  key '0xB4112585D386EB94'
  retries 2
  retry_delay 30
  not_if { node['kernel']['machine'] == 'ppc64le' }
  only_if { node['travis_build_environment']['hhvm']['enabled'] }
end

apt_repository 'hhvm-ppc-repository' do
  uri 'http://ppa.launchpad.net/ibmpackages/hhvm/ubuntu'
  distribution node['lsb']['codename']
  components ['main']
  key 'E7D1FA0C'
  retries 2
  retry_delay 30
  only_if { node['kernel']['machine'] == 'ppc64le' }
  only_if { node['travis_build_environment']['hhvm']['enabled'] }
end

package node['travis_build_environment']['hhvm']['package_name'] do
  options '--force-yes'
  action :install
  only_if { node['travis_build_environment']['hhvm']['enabled'] }
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
  mode 0o755
end

remote_file "#{hhvm_path}/bin/phpunit" do
  source 'https://phar.phpunit.de/phpunit.phar'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o755
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

%w[hhvm-repository hhvm-ppc-repository].each do |repo|
  apt_repository repo do
    action :remove
    only_if { node['travis_build_environment']['hhvm']['enabled'] }
    not_if { node['travis_build_environment']['hhvm']['keep_repo'] }
  end
end

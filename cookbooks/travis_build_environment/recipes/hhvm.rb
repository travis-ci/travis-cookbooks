if node['kernel']['machine'] == 'ppc64le'
  hhvm_uri = 'http://ppa.launchpad.net/ibmpackages/hhvm/ubuntu'
  key = "E7D1FA0C"
else
  hhvm_uri = 'https://dl.hhvm.com/ubuntu'
  key = %w[0x5a16e7281be7a449 0xB4112585D386EB94]
end

apt_repository 'hhvm-repository' do
  uri hhvm_uri
  distribution node['lsb']['codename']
  components ['main']
  arch 'amd64'
  keyserver 'keyserver.ubuntu.com'
  key key
  retries 2
  retry_delay 30
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

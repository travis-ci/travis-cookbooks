include_recipe "git"

remote_file "/tmp/phpenv-install.sh"  do
  source "https://raw.github.com/CHH/phpenv/master/bin/phpenv-install.sh"
  mode "0755"
end

bash "install phpenv" do
  user  node.travis_build_environment.user
  group node.travis_build_environment.group
  environment Hash["HOME" => node.travis_build_environment.home]
  code <<-EOF
  . /tmp/phpenv-install.sh
  EOF
  not_if "test -f #{node.travis_build_environment.home}/.phpenv/bin/phpenv"
end

directory "#{node.travis_build_environment.home}/.phpenv/versions" do
  owner  node.travis_build_environment.user
  group  node.travis_build_environment.group
  mode   "0755"
  action :create
end

cookbook_file "/etc/profile.d/phpenv.sh" do
  owner node.travis_build_environment.user
  group node.travis_build_environment.group
  mode 0755
end

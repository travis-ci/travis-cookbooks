include_recipe "git"
phpenv_path = "#{node.travis_build_environment.home}/.phpenv"

git "/tmp/phpenv" do
  user       node.travis_build_environment.user
  group      node.travis_build_environment.group
  repository node[:phpenv][:git][:repository]
  revision   node[:phpenv][:git][:revision]
  action     :checkout
end

bash "install phpenv" do
  user  node.travis_build_environment.user
  group node.travis_build_environment.group
  code <<-EOF
  PHPENV_ROOT="#{phpenv_path}" . /tmp/phpenv/bin/phpenv-install.sh
  cp /tmp/phpenv/extensions/rbenv-config-add /tmp/phpenv/extensions/rbenv-config-rm "#{phpenv_path}/libexec"
  EOF
  not_if "test -f #{phpenv_path}/bin/phpenv"
end

directory "#{phpenv_path}/versions" do
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

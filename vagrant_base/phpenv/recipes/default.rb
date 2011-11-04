include_recipe "git"

remote_file "/tmp/phpenv-install.sh"  do
  source "https://raw.github.com/CHH/phpenv/master/bin/phpenv-install.sh"
  mode "0755"
end

bash "install phpenv" do
  user node[:phpenv][:user]
  group node.phpenv.group
  environment Hash["HOME" => node.phpenv.home]
  code <<-EOF
  . /tmp/phpenv-install.sh
  EOF
  not_if "test -f #{node.phpenv.home}/.phpenv/bin/phpenv"
end

cookbook_file "/etc/profile.d/phpenv.sh" do
  owner node.phpenv.user
  group node.phpenv.group
  mode 0755
end

include_recipe "apt"
include_recipe "mysql::client"
include_recipe "postgresql::client"

case node[:platform]
  when "ubuntu", "debian"
    %w{libbz2-dev libc-client2007e-dev libcurl4-gnutls-dev libfreetype6-dev libgmp3-dev libjpeg8-dev libkrb5-dev libmcrypt-dev libpng12-dev libssl-dev libt1-dev libmhash-dev libexpat1-dev libxml2-dev libicu-dev libtidy-dev libxslt-dev language-pack-fr}.each do |pkg|
      package(pkg) { action :install }
    end

    link "/usr/lib/libpng.so" do
      to "/usr/lib/i386-linux-gnu/libpng.so"
    end
end

phpbuild_path = "#{node[:phpbuild][:home]}/.php-build"

git phpbuild_path do
  user       node[:phpbuild][:user]
  group      node[:phpbuild][:group]
  repository "git://github.com/CHH/php-build.git"
  revision   "559214ce65284936597b2208e3cb602205578a41"
  action     :checkout
end

git "/tmp/php-build-plugin-phpunit" do
  user       node[:phpbuild][:user]
  group      node[:phpbuild][:group]
  repository "git://github.com/CHH/php-build-plugin-phpunit.git"
  revision   "a6a5ce4a5126b90a02dd473b63f660515de7d183"
  action     :checkout
end

directory "#{phpbuild_path}/versions" do
  owner  node[:phpbuild][:user]
  group  node[:phpbuild][:group]
  mode   "0755"
  action :create
end

directory "#{phpbuild_path}/tmp" do
  owner  node[:phpbuild][:user]
  group  node[:phpbuild][:group]
  mode   "0755"
  action :create
end

bash "install php-build plugins" do
  user   node[:phpbuild][:user]
  group  node[:phpbuild][:group]
  code <<-EOF
  cp /tmp/php-build-plugin-phpunit/share/php-build/after-install.d/phpunit #{phpbuild_path}/share/php-build/after-install.d
  EOF
  not_if "test -f #{phpbuild_path}/share/php-build/after-install.d/phpunit"
end

template "#{phpbuild_path}/share/php-build/default_configure_options" do
  owner  node.phpfarm.user
  group  node.phpfarm.group
  source "default_configure_options.erb"
end

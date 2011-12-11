include_recipe "apt"
include_recipe "mysql::client"
include_recipe "postgresql::client"

case node[:platform]
  when "ubuntu", "debian"
    %w{libbz2-dev libc-client2007e-dev libcurl4-gnutls-dev libfreetype6-dev libgmp3-dev libjpeg8-dev libkrb5-dev libmcrypt-dev libpng12-dev libssl-dev libt1-dev libmhash-dev libexpat1-dev libxml2-dev libicu-dev libtidy-dev libxslt-dev language-pack-fr re2c}.each do |pkg|
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
  repository node[:phpbuild][:git][:repository]
  revision   node[:phpbuild][:git][:revision]
  action     :checkout
end

git "/tmp/php-build-plugin-phpunit" do
  user       node[:phpbuild][:user]
  group      node[:phpbuild][:group]
  repository node[:phpbuild][:phpunit_plugin][:git][:repository]
  revision   node[:phpbuild][:phpunit_plugin][:git][:revision]
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
  owner  node[:phpbuild][:user]
  group  node[:phpbuild][:group]
  source "default_configure_options.erb"
end

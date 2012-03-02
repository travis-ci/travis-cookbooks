include_recipe "apt"
include_recipe "git"

include_recipe "mysql::client"
include_recipe "postgresql::client"

include_recipe "libxml"
include_recipe "libssl"

case node[:platform]
when "ubuntu", "debian"
  %w{libbz2-dev libc-client2007e-dev libcurl4-gnutls-dev libfreetype6-dev libgmp3-dev libjpeg8-dev libmcrypt-dev libpng12-dev libt1-dev libmhash-dev libexpat1-dev libicu-dev libtidy-dev language-pack-fr re2c lemon}.each do |pkg|
    package(pkg) { action :install }
  end

  link "/usr/lib/libpng.so" do
    to "/usr/lib/i386-linux-gnu/libpng.so"
  end

  # in 11.10, we also have to symlink libjpeg. MK.
  if node[:platform_version].to_f >= 11.10
    link "/usr/lib/libjpeg.so" do
      to "/usr/lib/i386-linux-gnu/libjpeg.so"
    end
  end
end

phpbuild_path = "#{node.travis_build_environment.home}/.php-build"

git phpbuild_path do
  user       node.travis_build_environment.user
  group      node.travis_build_environment.group
  repository node[:phpbuild][:git][:repository]
  revision   node[:phpbuild][:git][:revision]
  action     :checkout
end

git "/tmp/php-build-plugin-phpunit" do
  user       node.travis_build_environment.user
  group      node.travis_build_environment.group
  repository node[:phpbuild][:phpunit_plugin][:git][:repository]
  revision   node[:phpbuild][:phpunit_plugin][:git][:revision]
  action     :checkout
end

directory "#{phpbuild_path}/versions" do
  owner  node.travis_build_environment.user
  group  node.travis_build_environment.group
  mode   "0755"
  action :create
end

directory "#{phpbuild_path}/tmp" do
  owner  node.travis_build_environment.user
  group  node.travis_build_environment.group
  mode   "0755"
  action :create
end

bash "install php-build plugins" do
  user   node.travis_build_environment.user
  group  node.travis_build_environment.group
  code <<-EOF
  cp /tmp/php-build-plugin-phpunit/share/php-build/after-install.d/phpunit #{phpbuild_path}/share/php-build/after-install.d
  EOF
  not_if "test -f #{phpbuild_path}/share/php-build/after-install.d/phpunit"
end

template "#{phpbuild_path}/share/php-build/default_configure_options" do
  owner  node.travis_build_environment.user
  group  node.travis_build_environment.group
  source "default_configure_options.erb"
end

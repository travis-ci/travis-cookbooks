include_recipe "apt"

case node[:platform]
  when "ubuntu", "debian"
    %w{libbz2-dev libc-client2007e-dev libcurl4-gnutls-dev libfreetype6-dev libgmp3-dev libjpeg62-dev libkrb5-dev libmcrypt-dev libpng12-dev libssl-dev libt1-dev libmhash-dev libexpat1-dev libxml2-dev libicu-dev libtidy-dev libxslt-dev language-pack-fr}.each do |pkg|
      package(pkg) { action :install }
    end
end

phpbuild_path = "#{node[:phpbuild][:home]}/.php-build"

git phpbuild_path do
  user       node[:phpbuild][:user]
  group      node[:phpbuild][:group]
  repository "git://github.com/CHH/php-build.git"
  revision   "693715de0b59ea0642e3e94c3a72d8cd76b1be49"
  action     :checkout
end

git "/tmp/php-build-plugin-phpunit" do
  user       node[:phpbuild][:user]
  group      node[:phpbuild][:group]
  repository "git://github.com/CHH/php-build-plugin-phpunit.git"
  revision   "0030458a985557671752afaeb7a28f8077b59be9"
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

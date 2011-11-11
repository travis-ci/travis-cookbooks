include_recipe "apt"

case node[:platform]
  when "ubuntu", "debian"
    %w{libbz2-dev libc-client2007e-dev libcurl4-gnutls-dev libfreetype6-dev libgmp3-dev libjpeg62-dev libkrb5-dev libmcrypt-dev libpng12-dev libssl-dev libt1-dev libmhash-dev libexpat1-dev libxml2-dev libicu-dev libtidy-dev libxslt-dev language-pack-fr}.each do |pkg|
      package(pkg) { action :install }
    end
end

phpbuild_path = "#{node[:phpbuild][:home]}/.php-build"

remote_file "/tmp/CHH-php-build.tar.gz" do
  source "https://github.com/CHH/php-build/tarball/master"
  mode "0755"
end

bash "extract php-build" do
  user node[:phpbuild][:user]
  group node[:phpbuild][:group]
  code <<-EOF
  tar xzf /tmp/CHH-php-build.tar.gz -C /tmp
  mv /tmp/CHH-php-build-ccfdb27 #{phpbuild_path}
  mkdir #{phpbuild_path}/tmp
  EOF
  not_if "test -f #{phpbuild_path}/bin/php-build"
end

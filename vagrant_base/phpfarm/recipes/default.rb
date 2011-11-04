include_recipe "apt"

case node['platform']
  when "ubuntu", "debian"
    %w{libbz2-dev libc-client2007e-dev libcurl4-gnutls-dev libfreetype6-dev libgmp3-dev libjpeg62-dev libkrb5-dev libmcrypt-dev libpng12-dev libssl-dev libt1-dev libmhash-dev libexpat1-dev libxml2-dev}.each do |pkg|
      package(pkg) { action :install }
    end
end

phpfarm_path = "#{node.phpfarm.home}/.phpfarm"

directory phpfarm_path do
  owner node.phpfarm.user
  group node.phpfarm.group
  mode  "0755"
  action :create
end

remote_file "/tmp/phpfarm-0.1.0.tar.bz2" do
  source "http://downloads.sourceforge.net/project/phpfarm/phpfarm/v0.1/phpfarm-0.1.0.tar.bz2"
  mode "0755"
end

bash "extract phpfarm" do
  user node.phpfarm.user
  group node.phpfarm.group
  code <<-EOF
  tar xjf /tmp/phpfarm-0.1.0.tar.bz2 -C #{phpfarm_path}
  mv #{phpfarm_path}/phpfarm-0.1.0/* #{phpfarm_path}
  rmdir #{phpfarm_path}/phpfarm-0.1.0
  EOF
  not_if "test -f #{phpfarm_path}/src/compile.sh"
end

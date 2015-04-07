# set up mysql-apt-config

apt_config_file = File.join(Chef::Config[:file_cache_path], 'mysql-apt-config.deb')

remote_file apt_config_file do
  source "http://dev.mysql.com/get/mysql-apt-config_#{node.mysql.deb.config.version}-2ubuntu#{node.platform_version}_all.deb"
end

execute "preseed mysql-apt-config" do
  command "debconf-set-selections /var/cache/local/preseeding/mysql-apt-config.seed"
  action :nothing
end

template "/var/cache/local/preseeding/mysql-apt-config.seed" do
  source "mysql-apt-config.seed.erb"
  owner "root"
  group "root"
  mode "0600"
  notifies :run, resources(:execute => "preseed mysql-apt-config"), :immediately
end

dpkg_package 'mysql-apt-config' do
  source apt_config_file
end

execute 'reconfigure mysql-apt-config' do
  command 'env DEBIAN_FRONTEND=noninteractive dpkg-reconfigure mysql-apt-config'
end

execute 'update APT packag list' do
  command 'apt-get update'
end

apt_config_file = File.join(Chef::Config[:file_cache_path], 'mysql-apt-config.deb')

remote_file apt_config_file do
  source "http://dev.mysql.com/get/mysql-apt-config_#{node.mysql.deb.config.version}-2ubuntu#{node.platform_version}_all.deb"
end

dpkg_package 'mysql-apt-config' do
  source apt_config_file
  response_file 'mysql-apt-config.seed.erb'
end

%w(
  mysql-common
  libmysqlclient18
  libmysqlclient-dev
  mysql-community-client
  mysql-client
  mysql-community-server
).each do |pkg|
  package pkg
end

apt_package 'mysql-server' do
  response_file 'mysql-server-deb.seed.erb'
  action :install
end
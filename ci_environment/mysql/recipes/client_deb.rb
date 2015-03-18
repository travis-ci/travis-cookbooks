# Install MySQL client from deb packages from mysql.com

version = node.mysql.deb.version
version_major_minor = /^\d+\.\d+/.match(version)[0]

tar_path = File.join(Chef::Config[:file_cache_path], 'mysql-server-deb-bundle.tar')

package 'libaio1'

remote_file tar_path do
  source "http://dev.mysql.com/get/Downloads/MySQL-#{version_major_minor}/mysql-server_#{version}-1ubuntu#{node.platform_version}_amd64.deb-bundle.tar"
  checksum node.mysql.deb.checksum[node.platform_version][node.mysql.deb.version]
  not_if "test -f #{tar_path}"
end

bash "expand MySQL tar file" do
  cwd File.dirname(tar_path)
  code "tar xf #{tar_path}"
  not_if "ls *mysql*.deb"
end

node.mysql.deb.client.packages.each do |pkg|
  pkg_name = "#{pkg}_#{version}-1ubuntu#{node.platform_version}_amd64.deb"
  dpkg_package pkg do
    package_name pkg_name
    source File.join(File.dirname(tar_path), pkg_name)
    action :install
  end
end
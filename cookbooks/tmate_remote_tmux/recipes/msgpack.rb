# frozen_string_literal: true

package "build-essential"

msgpack_src_dir = "/usr/src/msgpack"
msgpack_tar = "msgpack-1.3.0.tar.gz"
msgpack_url = "https://github.com/msgpack/msgpack-c/releases/download/cpp-1.3.0/msgpack-1.3.0.tar.gz"
msgpack_sum = "b539c9aa1bbe728b9c43bfae7120353461793fa007363aae8e4bb8297948b4b7"

directory msgpack_src_dir do
  action :create
end

execute "install-msgpack" do
  cwd msgpack_src_dir
  command "./configure --prefix=/usr && make && make install"
  action :nothing
end

execute "msgpack-extract-source" do
  command "tar zxf #{Chef::Config.file_cache_path}/#{msgpack_tar} --strip-components 1 -C #{msgpack_src_dir}"
  creates "#{msgpack_src_dir}/COPYING"
  only_if { File.exist?("#{Chef::Config.file_cache_path}/#{msgpack_tar}") }
  action :run
  notifies :run, "execute[install-msgpack]", :immediately
end

remote_file "#{Chef::Config.file_cache_path}/#{msgpack_tar}" do
  source msgpack_url
  mode 0o644
  checksum msgpack_sum
  notifies :run, "execute[msgpack-extract-source]", :immediately
end

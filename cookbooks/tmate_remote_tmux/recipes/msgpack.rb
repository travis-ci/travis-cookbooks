# frozen_string_literal: true

package "build-essential"

msgpack_src_dir = "/usr/src/msgpack"
msgpack_tar = "msgpack-cxx-6.1.0.tar.gz"
msgpack_url = "https://github.com/msgpack/msgpack-c/releases/download/cpp-6.1.0/msgpack-cxx-6.1.0.tar.gz"
msgpack_sum = "23ede7e93c8efee343ad8c6514c28f3708207e5106af3b3e4969b3a9ed7039e7"

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
  only_if { ::File.exist?("#{Chef::Config.file_cache_path}/#{msgpack_tar}") }
  action :run
  notifies :run, "execute[install-msgpack]", :immediately
end

remote_file "#{Chef::Config.file_cache_path}/#{msgpack_tar}" do
  source msgpack_url
  mode '644'
  checksum msgpack_sum
  notifies :run, "execute[msgpack-extract-source]", :immediately
end

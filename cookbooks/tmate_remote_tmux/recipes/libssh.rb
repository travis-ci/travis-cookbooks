package "build-essential"
package "cmake"

libssh_src_dir = "/usr/src/libssh-git"
execute "install-libssh" do
  cwd libssh_src_dir
  command "mkdir -p build && cd build && cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DWITH_EXAMPLES=OFF -DWITH_SFTP=OFF .. && make && make install"
  action :nothing
end

git libssh_src_dir do
  repository "https://github.com/nviennot/libssh.git"
  revision 'v0-7'
  action :sync
  notifies :run, "execute[install-libssh]", :immediately
end


# Using the git version for latency metrics instead of the official version.

# libssh_src_dir = "/usr/src/libssh"
# libssh_tar = "libssh-0.7.2.tar.xz"
# libssh_url = "https://red.libssh.org/attachments/download/177/libssh-0.7.2.tar.xz"
# libssh_sum = "a32c45b9674141cab4bde84ded7d53e931076c6b0f10b8fd627f3584faebae62"

# directory libssh_src_dir do
  # action :create
# end

# execute "libssh-extract-source" do
  # command "tar xf #{Chef::Config.file_cache_path}/#{libssh_tar} --strip-components 1 -C #{libssh_src_dir}"
  # creates "#{libssh_src_dir}/INSTALL"
  # only_if do File.exist?("#{Chef::Config.file_cache_path}/#{libssh_tar}") end
  # action :run
  # notifies :run, "execute[install-libssh]", :immediately
# end

# remote_file "#{Chef::Config.file_cache_path}/#{libssh_tar}" do
  # source libssh_url
  # mode 0644
  # checksum libssh_sum
  # notifies :run, "execute[libssh-extract-source]", :immediately
# end

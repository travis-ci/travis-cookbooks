# frozen_string_literal: true

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

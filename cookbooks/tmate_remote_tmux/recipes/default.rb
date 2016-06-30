package "build-essential"
package "autoconf"
package "cmake"
package "pkg-config"
package "libtool"
package "libevent-dev"
package "libncurses-dev"
package "libssl-dev"
package "zlib1g-dev"

include_recipe "tmate_remote_tmux::msgpack"
include_recipe "tmate_remote_tmux::libssh"
include_recipe "tmate_remote_tmux::rename_openssh_port"

git node[:tmate_remote_tmux][:app_path] do
  repository "https://github.com/tmate-io/tmate-slave.git"
  revision 'master'
  action :sync
  notifies :run, "bash[compile tmate_remote_tmux]", :immediately
end

bash "compile tmate_remote_tmux" do
  cwd node[:tmate_remote_tmux][:app_path]
  code "./autogen.sh && ./configure --enable-debug --enable-latency && make"
  action :nothing
end

link "#{node[:tmate_remote_tmux][:app_path]}/tmate-remote-tmux" do
  to "tmate-slave"
end

template '/etc/init/tmate-remote-tmux.conf' do
  source 'tmate-remote-tmux.conf.erb'
  owner 'root'
  mode '0644'
  variables app_path:    node[:tmate_remote_tmux][:app_path],
            keys_dir:    node[:tmate_remote_tmux][:keys_dir],
            use_syslog:  node[:tmate_remote_tmux][:use_syslog],
            log_level:   node[:tmate_remote_tmux][:log_level],
            listen_port: node[:tmate_remote_tmux][:listen_port],
            has_proxy:   node[:tmate_remote_tmux][:has_proxy]
end

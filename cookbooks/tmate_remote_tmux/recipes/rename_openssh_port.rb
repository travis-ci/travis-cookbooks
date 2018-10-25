# frozen_string_literal: true

sshd_config_file = "/etc/ssh/sshd_config"

ruby_block "Change SSH port" do
  block do
    file = Chef::Util::FileEdit.new(sshd_config_file)
    file.search_file_replace(/^Port [0-9]+$/, "Port #{node[:tmate_remote_tmux][:openssh_port]}")
    file.write_file
  end

  only_if { File.exist?(sshd_config_file) }
end

package 'openssh'

cookbook_file "/etc/init/ssh.conf" do
  owner "root"
  group "root"
  mode 0644

  source "etc/init/ssh.conf"
end
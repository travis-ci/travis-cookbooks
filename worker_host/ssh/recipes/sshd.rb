service "ssh" do
  supports :restart => true, :reload => true
  action :enable
end

template "/etc/ssh/sshd_config" do
  source "sshd_config.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, resources(:service => "ssh")
end

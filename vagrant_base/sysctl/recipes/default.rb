template "/etc/sysctl.conf" do
  source "sysctl.conf.erb"
  owner  "root"
  group  "root"
  mode   0644
end
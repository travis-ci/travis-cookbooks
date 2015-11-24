# Persist Kernel Shared Memory Limits for next machine reboots
template "/etc/sysctl.d/30-travis-shm.conf" do
  source "30-travis-shm.conf.erb"
  owner  "root"
  group  "root"
  mode   0644
end

execute "Update kernel shared memory settings at runtime" do
  command "sysctl -p /etc/sysctl.d/30-travis-shm.conf"
  #TODO only if template above has been modified...
end

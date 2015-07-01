execute 'update sysctl travis-shm' do
  command 'sysctl -p /etc/sysctl.d/30-travis-shm.conf'
  action :nothing
end

# Persist Kernel Shared Memory Limits for next machine reboots
template '/etc/sysctl.d/30-travis-shm.conf' do
  source '30-travis-shm.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :run, 'execute[update sysctl travis-shm]'
end

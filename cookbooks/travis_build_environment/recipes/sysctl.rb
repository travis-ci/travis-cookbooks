execute 'update sysctl travis-shm' do
  command 'sysctl -p /etc/sysctl.d/30-travis-shm.conf'
  action :nothing
end

file '/etc/sysctl.d/30-travis-shm.conf' do
  content "kernel.shmmax=#{node['travis_build_environment']['sysctl_kernel_shmmax']}\n"
  owner 'root'
  group 'root'
  mode 0o644
  notifies :run, 'execute[update sysctl travis-shm]'
end

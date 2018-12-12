# frozen_string_literal: true

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

execute 'update sysctl travis-disable-ipv6' do
  command 'sysctl -p /etc/sysctl.d/99-travis-disable-ipv6.conf'
  action :nothing
end

file '/etc/sysctl.d/99-travis-disable-ipv6.conf' do
  content <<-IPV6_CONFIG.gsub(/^\s+> ?/, '')
    > net.ipv6.conf.all.disable_ipv6 = 1
    > net.ipv6.conf.default.disable_ipv6 = 1
  IPV6_CONFIG
  owner 'root'
  group 'root'
  mode 0o644
  only_if { node['travis_build_environment']['sysctl_disable_ipv6'] }
  notifies :run, 'execute[update sysctl travis-disable-ipv6]'
end

execute 'update sysctl travis-enable-ipv4-forwarding' do
  command 'sysctl -p /etc/sysctl.d/99-travis-enable-ipv4-forwarding.conf'
  action :nothing
end

file '/etc/sysctl.d/99-travis-enable-ipv4-forwarding.conf' do
  content "net.ipv4.ip_forward = 1\n"
  owner 'root'
  group 'root'
  mode 0o644
  only_if { node['travis_build_environment']['sysctl_enable_ipv4_forwarding'] }
  notifies :run, 'execute[update sysctl travis-enable-ipv4-forwarding]'
end

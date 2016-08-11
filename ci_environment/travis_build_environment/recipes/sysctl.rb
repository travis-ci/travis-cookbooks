execute 'update sysctl travis-disable-ipv6' do
  command 'sysctl -p /etc/sysctl.d/99-travis-disable-ipv6.conf'
  action :nothing
end

file '/etc/sysctl.d/99-travis-disable-ipv6.conf' do
  content <<-EOF.gsub(/^\s+> ?/, '')
    > net.ipv6.conf.all.disable_ipv6 = 1
    > net.ipv6.conf.default.disable_ipv6 = 1
  EOF
  owner 'root'
  group 'root'
  mode 0o644
  only_if { node['travis_build_environment']['sysctl_disable_ipv6'] }
  notifies :run, 'execute[update sysctl travis-disable-ipv6]'
end

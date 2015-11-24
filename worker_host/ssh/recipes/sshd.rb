service_provider = Chef::Provider::Service::Upstart if 'ubuntu' == node['platform'] &&
  Chef::VersionConstraint.new('>= 12.04').include?(node['platform_version'])

service "ssh" do
  provider service_provider
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

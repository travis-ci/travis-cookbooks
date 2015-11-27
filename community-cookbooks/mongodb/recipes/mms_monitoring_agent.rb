Chef::Log.warn 'Found empty mms_agent.api_key attribute' if node['mongodb']['mms_agent']['api_key'].nil?

arch = node[:kernel][:machine]
agent_type = 'monitoring'
package = node['mongodb']['mms_agent']['package_url'] % { :agent_type => agent_type }
package_opts = ''

case node.platform_family
when 'debian'
  arch = 'amd64' if arch == 'x86_64'
  package = "#{package}_#{node[:mongodb][:mms_agent][:monitoring][:version]}_#{arch}.deb"
  provider = Chef::Provider::Package::Dpkg
  # Without this, if the package changes the config files that we rewrite install fails
  package_opts = '--force-confold'
when 'rhel'
  package = "#{package}-#{node[:mongodb][:mms_agent][:monitoring][:version]}.#{arch}.rpm"
  provider = Chef::Provider::Package::Rpm
else
  Chef::Log.warn('Unsupported platform family for MMS Agent.')
  return
end

remote_file "#{Chef::Config[:file_cache_path]}/mongodb-mms-monitoring-agent" do
  source package
end

package 'mongodb-mms-monitoring-agent' do
  source "#{Chef::Config[:file_cache_path]}/mongodb-mms-monitoring-agent"
  provider provider
  options package_opts
end

template '/etc/mongodb-mms/monitoring-agent.config' do
  source 'mms_agent_config.erb'
  owner node['mongodb']['mms_agent']['user']
  group node['mongodb']['mms_agent']['group']
  mode 0600
  variables(
      :config => node['mongodb']['mms_agent']['monitoring']
  )
  action :create
  notifies :restart, 'service[mongodb-mms-monitoring-agent]', :delayed
end

service 'mongodb-mms-monitoring-agent' do
  provider Chef::Provider::Service::Upstart if node['mongodb']['apt_repo'] == 'ubuntu-upstart'
  # restart is broken on rhel (MMS-1597)
  supports :start => true, :stop => true, :restart => true, :status => true
  action :nothing
end

Chef::Log.warn 'Found empty mms_agent.api_key attribute' if node['mongodb']['mms_agent']['api_key'].nil?

arch = node[:kernel][:machine]
agent_type = 'backup'
package = node['mongodb']['mms_agent']['package_url'] % { :agent_type => agent_type }
package_opts = ''

case node.platform_family
when 'debian'
  arch = 'amd64' if arch == 'x86_64'
  package = "#{package}_#{node[:mongodb][:mms_agent][:backup][:version]}_#{arch}.deb"
  provider = Chef::Provider::Package::Dpkg
  # Without this, if the package changes the config files that we rewrite install fails
  package_opts = '--force-confold'
when 'rhel'
  package = "#{package}-#{node[:mongodb][:mms_agent][:backup][:version]}.#{arch}.rpm"
  provider = Chef::Provider::Package::Rpm
else
  Chef::Log.warn('Unsupported platform family for MMS Agent.')
  return
end

remote_file "#{Chef::Config[:file_cache_path]}/mongodb-mms-backup-agent" do
  source package
end

package 'mongodb-mms-backup-agent' do
  source "#{Chef::Config[:file_cache_path]}/mongodb-mms-backup-agent"
  provider provider
  options package_opts
end

template '/etc/mongodb-mms/backup-agent.config' do
  source 'mms_agent_config.erb'
  owner node['mongodb']['mms_agent']['user']
  group node['mongodb']['mms_agent']['group']
  mode 0600
  variables(
      :config => node['mongodb']['mms_agent']['backup']
  )
  action :create
  notifies :restart, 'service[mongodb-mms-backup-agent]', :delayed
end

service 'mongodb-mms-backup-agent' do
  provider Chef::Provider::Service::Upstart if node['mongodb']['apt_repo'] == 'ubuntu-upstart'
  # restart is broken on rhel (MMS-1597)
  supports :start => true, :stop => true, :restart => true, :status => true
  action :nothing
end

#
# Cookbook Name:: duo_unix
# Recipe:: default
#

package %w(libssl-dev libpam-dev) do
  action :upgrade
end

apt_repository 'duosecurity' do
  uri 'http://pkg.duosecurity.com/Ubuntu'
  distribution 'trusty'
  components ['main']
  key 'duosecurity.gpg'
  retries 2
  retry_delay 30
end

package 'duo-unix' do
  action :upgrade
end

template '/etc/duo/login_duo.conf' do
  source 'login_duo.conf.erb'
  owner node['duo_unix']['user']
  group node['duo_unix']['group'] || node['duo_unix']['user']
  mode 0600
end

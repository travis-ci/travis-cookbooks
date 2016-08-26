# Cookbook Name:: travis_duo
# Recipe:: default

package %w(libssl-dev libpam-dev) do
  action :upgrade
end

apt_repository 'duosecurity' do
  uri 'http://pkg.duosecurity.com/Ubuntu'
  distribution node['lsb']['codename']
  components %w(main)
  key 'https://duo.com/APT-GPG-KEY-DUO'
  retries 2
  retry_delay 30
end

package 'duo-unix' do
  action :upgrade
end

template '/etc/duo/login_duo.conf' do
  source 'login_duo.conf.erb'
  owner node['travis_duo']['user']
  group node['travis_duo']['group'] || node['travis_duo']['user']
  mode 0o600
end

template '/etc/duo/pam_duo.conf' do
  source 'pam_duo.conf.erb'
  owner node['travis_duo']['user']
  group node['travis_duo']['group'] || node['travis_duo']['user']
  mode 0o600
end

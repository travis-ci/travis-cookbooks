apt_repository 'rwky-redis' do
  uri 'http://ppa.launchpad.net/rwky/redis/ubuntu'
  distribution node['lsb']['codename']
  components ['main']
  key '5862E31D'
  keyserver 'hkp://ha.pool.sks-keyservers.net'
  retries 2
  retry_delay 30
  action :add
end

package 'redis-server' do
  action :install
end

service 'redis-server' do
  provider Chef::Provider::Service::Upstart
  supports restart: true, status: true, reload: true
  if node['travis_build_environment']['redis']['service_enabled']
    action %i(enable start)
  else
    action %i(disable start)
  end
end

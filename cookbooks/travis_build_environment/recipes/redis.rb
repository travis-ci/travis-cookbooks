apt_repository 'chris-lea-redis-server' do
  uri 'http://ppa.launchpad.net/chris-lea/redis-server/ubuntu'
  distribution node['lsb']['codename']
  components ['main']
  key 'C7917B12'
  keyserver 'hkp://keyserver.ubuntu.com'
  retries 2
  retry_delay 30
  action :add
end

package 'redis-server' do
  action :install
end

service 'redis-server' do
  provider Chef::Provider::Service::Init::Debian, service
  supports restart: true, status: true, reload: true
  if node['travis_build_environment']['redis']['service_enabled']
    action %i(enable start)
  else
    action %i(disable start)
  end
end

# frozen_string_literal: true

apt_repository 'ppa:redis-server' do
  uri 'ppa:chris-lea/redis-server'
end

package 'redis-server' do
  action :install
end

service 'redis-server' do
  if node['travis_build_environment']['redis']['service_enabled']
    action %i[enable start]
  else
    action %i[disable start]
  end
end

apt_repository 'ppa:redis-server' do
  not_if { node['travis_build_environment']['redis']['keep_repo'] }
  action :remove
end

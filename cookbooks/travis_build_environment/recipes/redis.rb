# frozen_string_literal: true

apt_repository 'ppa:redis-server' do
  uri 'ppa:chris-lea/redis-server'
end

package %w[redis-server redis-tools] do
  action :install
end

execute 'redis do not listen to ipv6' do
  command "sed -ie 's/^bind.*/bind 127.0.0.1/' /etc/redis/redis.conf"
end

service 'redis-server' do
  if node['travis_build_environment']['redis']['service_enabled']
    action %i[enable restart]
  else
    action %i[disable restart]
  end
end

apt_repository 'ppa:redis-server' do
  not_if { node['travis_build_environment']['redis']['keep_repo'] }
  action :remove
end

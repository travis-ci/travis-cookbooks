# frozen_string_literal: true

case node['lsb']['codename']
when 'focal', 'jammy', 'noble'
  apt_repository 'redis' do
    uri "https://packages.redis.io/deb"
    components ['main']
    arch 'amd64'
    distribution node['lsb']['codename']
    key ['https://packages.redis.io/gpg']
    action :add
  end

  package %w(redis redis-server redis-tools) do
    action :install
  end

  execute 'redis do not listen to ipv6' do
    command "sed -i 's/^bind .*/bind 127.0.0.1/' /etc/redis/redis.conf"
    only_if { ::File.exist?('/etc/redis/redis.conf') }
  end

  service 'redis-server' do
    if node['travis_build_environment']['redis']['service_enabled']
      action %i(enable restart)
    else
      action %i(disable stop)
    end
  end

when 'xenial', 'bionic'
  apt_repository 'redis-ppa' do
    uri 'ppa:chris-lea/redis-server'
  end

  package %w(redis-server redis-tools) do
    action :install
  end

  execute 'redis do not listen to ipv6' do
    command "sed -i 's/^bind .*/bind 127.0.0.1/' /etc/redis/redis.conf"
    only_if { ::File.exist?('/etc/redis/redis.conf') }
  end

  service 'redis-server' do
    if node['travis_build_environment']['redis']['service_enabled']
      action %i(enable restart)
    else
      action %i(disable stop)
    end
  end

  apt_repository 'redis-ppa' do
    not_if { node['travis_build_environment']['redis']['keep_repo'] }
    action :remove
  end
end

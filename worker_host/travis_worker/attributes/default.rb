default[:travis][:worker][:home] = '/home/deploy'
default[:travis][:worker][:repository] = 'git://github.com/travis-ci/travis-worker.git'
default[:travis][:worker][:ref] = 'master'
default[:travis][:worker][:amqp] = {
  :host => 'localhost',
  :port => 1234,
  :username => 'travis',
  :password => 'travis',
  :virtual_host => 'travis'
}
default[:travis][:worker][:vms] = 20
default[:travis][:worker][:env] = 'ruby'
default[:travis][:worker][:hostname] = "#{node[:travis][:worker][:env]}.worker.travis-ci.com"
default[:travis][:worker][:log_level] = 'info'
default[:travis][:worker][:workers] = 1

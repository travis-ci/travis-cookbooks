default[:travis][:worker][:home] = '/mnt/ssd/travis/worker'
default[:travis][:worker][:repository] = 'git://github.com/travis-ci/travis-worker.git'
default[:travis][:worker][:ref] = 'master'
default[:travis][:worker][:amqp] = {
  :host => 'localhost',
  :port => 1234,
  :username => 'travis',
  :password => 'travis',
  :virtual_host => 'travis'
}
default[:travis][:worker][:vms] = 6
default[:travis][:worker][:env] = 'ruby'

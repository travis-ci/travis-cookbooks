cassandra_version = '2.1.2'

default['cassandra']['version'] = cassandra_version
default['cassandra']['tarball']['url'] = "http://archive.apache.org/dist/cassandra/#{cassandra_version}/apache-cassandra-#{cassandra_version}-bin.tar.gz"
default['cassandra']['tarball']['md5'] = '9d6fd1fb9cf4836ef168796fed8f1282'
default['cassandra']['user'] = 'cassandra'
default['cassandra']['jvm']['xms'] = 32
default['cassandra']['jvm']['xmx'] = 512
default['cassandra']['limits']['memlock'] = 'unlimited'
default['cassandra']['limits']['nofile'] = 48_000
default['cassandra']['installation_dir'] = '/usr/local/cassandra'
default['cassandra']['bin_dir'] = '/usr/local/cassandra/bin'
default['cassandra']['lib_dir'] = '/usr/local/cassandra/lib'
default['cassandra']['conf_dir'] = '/usr/local/cassandra/conf'
default['cassandra']['data_root_dir'] = '/var/lib/cassandra/'
default['cassandra']['log_dir'] = '/var/log/cassandra/'
default['cassandra']['ipv6'] = true
default['cassandra']['service']['enabled'] = false

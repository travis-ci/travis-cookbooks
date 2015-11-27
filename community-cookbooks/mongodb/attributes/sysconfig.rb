include_attribute 'mongodb::default'

default['mongodb']['sysconfig']['DAEMON'] = '/usr/bin/$NAME'
default['mongodb']['sysconfig']['DAEMON_USER'] = node['mongodb']['user']
default['mongodb']['sysconfig']['DAEMON_OPTS'] = "--config #{node['mongodb']['dbconfig_file']}"
default['mongodb']['sysconfig']['CONFIGFILE'] = node['mongodb']['dbconfig_file']
default['mongodb']['sysconfig']['ENABLE_MONGODB'] = 'yes'

# these are backward compat purposes
default['mongodb']['sysconfig']['DAEMONUSER'] = node['mongodb']['sysconfig']['DAEMON_USER']
default['mongodb']['sysconfig']['ENABLE_MONGOD'] = node['mongodb']['sysconfig']['ENABLE_MONGODB']
default['mongodb']['sysconfig']['ENABLE_MONGO'] = node['mongodb']['sysconfig']['ENABLE_MONGODB']

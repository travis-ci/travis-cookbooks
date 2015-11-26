# All the configuration files that can be dumped
# the attribute-based-configuration
# dump anything into default['mongodb']['config'][<setting>] = <value>
# these options are in the order of mongodb docs

include_attribute 'mongodb::default'

default['mongodb']['config']['port'] = 27017
default['mongodb']['config']['bind_ip'] = '0.0.0.0'
# Workaround for opscode/chef#1507, which prevents users from
# unsetting our default with a nil override.
# So we make sure to unset logpath when syslog is set since the two
# settings are incompatible.
# For more information see: edelight/chef-mongodb#310
unless node['mongodb']['config']['syslog']
  default['mongodb']['config']['logpath'] = '/var/log/mongodb/mongodb.log'
end
default['mongodb']['config']['logappend'] = true
# The platform_family? syntax in attributes files was added in Chef 11
# if node.platform_family?("rhel", "fedora") then
case node['platform_family']
when 'rhel', 'fedora'
  default['mongodb']['config']['fork'] = true
  default['mongodb']['config']['pidfilepath'] = '/var/run/mongodb/mongodb.pid'
else
  default['mongodb']['config']['fork'] = false
end
default['mongodb']['config']['dbpath'] = '/var/lib/mongodb'
default['mongodb']['config']['nojournal'] = false
default['mongodb']['config']['rest'] = false
default['mongodb']['config']['smallfiles'] = false
default['mongodb']['config']['oplogSize'] = nil

default['mongodb']['config']['replSet'] = nil
default['mongodb']['config']['keyFile'] = '/etc/mongodb.key' if node['mongodb']['key_file_content']

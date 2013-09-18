default['postgresql']['default_version']     = '9.1'
default['postgresql']['alternate_versions']  = %w(9.2 9.3)

default['postgresql']['enabled']             = true
default['postgresql']['port']                = 5432
default['postgresql']['ssl']                 = true
default['postgresql']['max_connections']     = 255
default['postgresql']['fsync']               = 'off'   # disabled for CI purpose
default['postgresql']['full_page_writes']    = 'off'   # disabled for CI purpose
default['postgresql']['client_min_messages'] = 'error' # suppress warning output from build clients


default['postgresql']['data_on_ramfs']       = true   # enabled for CI purpose

if node['postgresql']['data_on_ramfs']
  include_attribute 'ramfs::default'
  default['postgresql']['data_dir']          = "#{node['ramfs']['dir']}/postgresql"
else
  default['postgresql']['data_dir']          = '/var/lib/postgresql'
end

default['postgresql']['client_packages']     = %w(postgresql-client libpq-dev)

default['postgresql']['postgis_version']     = '2.1'

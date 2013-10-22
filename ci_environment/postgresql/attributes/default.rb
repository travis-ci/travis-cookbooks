include_attribute 'travis_build_environment'

default['postgresql']['default_version']     = '9.1'
default['postgresql']['alternate_versions']  = %w(9.2 9.3)

default['postgresql']['enabled']             = true    # is default instance started on machine boot?

default['postgresql']['port']                = 5432
default['postgresql']['ssl']                 = true
default['postgresql']['max_connections']     = 255
default['postgresql']['fsync']               = false   # disabled for CI purpose
default['postgresql']['full_page_writes']    = false   # disabled for CI purpose
default['postgresql']['client_min_messages'] = 'error' # suppress warning output from build clients

default['postgresql']['data_on_ramfs']       = true    # enabled for CI purpose

if node['postgresql']['data_on_ramfs']
  include_attribute 'ramfs::default'
  default['postgresql']['data_dir']          = "#{node['ramfs']['dir']}/postgresql"
else
  default['postgresql']['data_dir']          = '/var/lib/postgresql'
end

default['postgresql']['contrib_modules']     = true    # enabled to install additional modules, like `hstore`
                                                       # (see full list at http://www.postgresql.org/docs/devel/static/contrib.html)

default['postgresql']['client_packages']     = %w(postgresql-client libpq-dev)

default['postgresql']['postgis_version']     = '2.1'

default['postgresql']['superusers']          = [ node['travis_build_environment']['user'], 'rails' ]


# frozen_string_literal: true

default['travis_postgresql']['default_version'] = '9.2'
default['travis_postgresql']['alternate_versions'] = %w(9.3 9.4 9.5 9.6)

default['travis_postgresql']['enabled'] = true # is default instance started on machine boot?

default['travis_postgresql']['port'] = 5432
default['travis_postgresql']['ssl'] = true
default['travis_postgresql']['max_connections'] = 255
default['travis_postgresql']['fsync'] = false # disabled for CI purpose
default['travis_postgresql']['full_page_writes'] = false # disabled for CI purpose
default['travis_postgresql']['client_min_messages'] = 'error' # suppress warning output from build clients

default['travis_postgresql']['contrib_modules'] = true # enabled to install additional modules, like `hstore`
# (see full list at http://www.postgresql.org/docs/devel/static/contrib.html)

default['travis_postgresql']['client_packages'] = %w(postgresql-client libpq-dev)

default['travis_postgresql']['postgis_version'] = '2.4'

default['travis_postgresql']['superusers'] = %w(travis rails)

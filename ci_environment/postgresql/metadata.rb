name              "postgresql"
maintainer        "Travis CI Team"
maintainer_email  "contact@travis-ci.org"
license           "Apache 2.0"
description       "Installs PostgreSQL instance(s) for Continuation Integration purposes"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "2.0.0"
recipe            "postgresql::default",       "Install PostgreSQL instance(s)"
recipe            "postgresql::postgis",       "Install PostGIS extension"

supports 'ubuntu', '= 12.04'

depends  'ramfs'

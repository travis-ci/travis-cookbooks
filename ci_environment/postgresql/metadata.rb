name              "postgresql"
maintainer        "Travis CI Team"
maintainer_email  "contact@travis-ci.org"
license           "Apache 2.0"
description       "Installs PostgreSQL instance(s) for Continuation Integration purposes"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "2.0.1"

recipe            "postgresql::default",      "Install all PostgreSQL components for a CI environment"

# sub-recipes included by 'default' recipe:

recipe            "postgresql::client",       "Install PostgreSQL client components"
recipe            "postgresql::all_packages", "Install all PostgreSQL apt packages for both server and client sides"
recipe            "postgresql::ci_server",    "Customize PostgreSQL server(s), optimized for CI context"
recipe            "postgresql::postgis",      "Install PostGIS extension"
recipe            "postgresql::pgdg",         "Configure 'PostgreSQL Development Group' Apt Repostitory"

supports          'ubuntu', '= 12.04'

depends           'apt'
depends           'ramfs'

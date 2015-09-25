name 'travis_rebar'
# maintainer 'Ward Bekker'
# maintainer_email 'ward@equanimity.nl'
maintainer 'Travis CI GmbH'
maintainer_email 'contact+travis-cookbooks-travis-rebar@travis-ci.org'
license 'Apache 2.0'
description 'Installs rebar for managing Erlang applications.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.0.0'

depends 'travis_build_environment'
depends 'travis_kerl'

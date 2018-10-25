# frozen_string_literal: true

version = '1.9.8'

default['travis_phantomjs']['version'] = version
default['travis_phantomjs']['arch'] = node['kernel']['machine']
default['travis_phantomjs']['tarball']['url'] = ::File.join(
  'https://s3.amazonaws.com/travis-phantomjs/binaries',
  node['platform'],
  node['platform_version'],
  node['kernel']['machine'],
  "phantomjs-#{version}.tar.bz2"
)
default['travis_phantomjs']['tarball']['checksum'] = '0afac5ea87f77f567dbc65ba586371b62b0cca1a440c2f9d122e5520bb522c6c'

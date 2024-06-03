# frozen_string_literal: true

groovy_version = '4.0.15'

default['travis_groovy']['version'] = groovy_version
default['travis_groovy']['installation_dir'] = '/usr/local/groovy'
default['travis_groovy']['url'] = "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-binary-#{groovy_version}.zip"
default['travis_groovy']['checksum'] = '31d96c1e1cf75c7e8173cdcef9bed1e3edd4e87e6400400584220e0bb42892e5'

# frozen_string_literal: true

groovy_version = '5.0.0-rc-1'

default['travis_groovy']['version'] = groovy_version
default['travis_groovy']['installation_dir'] = '/usr/local/groovy'
default['travis_groovy']['url'] = "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-binary-#{groovy_version}.zip"
default['travis_groovy']['checksum'] = 'd248907a133cdb02eae2a7973e746abbf18241726e1d006eea579025ad7b234e'

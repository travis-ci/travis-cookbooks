# frozen_string_literal: true

groovy_version = '2.4.21'

default['travis_groovy']['version'] = groovy_version
default['travis_groovy']['installation_dir'] = '/usr/local/groovy'
default['travis_groovy']['url'] = "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-binary-#{groovy_version}.zip"
default['travis_groovy']['checksum'] = '2f0f59aeaa054a241705b102111a2d823c19ee0f840a6c5bb3e2d26907058f40'

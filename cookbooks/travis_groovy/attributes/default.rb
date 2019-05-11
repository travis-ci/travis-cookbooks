# frozen_string_literal: true

groovy_version = '2.4.5'

default['travis_groovy']['version'] = groovy_version
default['travis_groovy']['installation_dir'] = '/usr/local/groovy'
default['travis_groovy']['url'] = "http://dl.bintray.com/groovy/maven/apache-groovy-binary-#{groovy_version}.zip"
default['travis_groovy']['checksum'] = '87e8e9af1f718b84c9bca5a8c42425aadb9e97d8e4ad64e0c91f7c1454cd4caa'

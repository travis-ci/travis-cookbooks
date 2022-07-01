# frozen_string_literal: true

groovy_version = '4.0.3'

default['travis_groovy']['version'] = groovy_version
default['travis_groovy']['installation_dir'] = '/usr/local/groovy'
default['travis_groovy']['url'] = "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-binary-#{groovy_version}.zip"
default['travis_groovy']['checksum'] = 'ddfc8e26fdcf3626d1c83f28d198c3e4e616a72337ca6e46fcaca09e7a4bb37f'

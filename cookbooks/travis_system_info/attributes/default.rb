# frozen_string_literal: true

include_attribute 'travis_build_environment'

default['travis_system_info']['commands_file'] = ''
default['travis_system_info']['defaults_file'] = '/etc/default/travis-system-info'
default['travis_system_info']['dest_dir'] = '/usr/share/travis'
default['travis_system_info']['gem_url'] = 'https://s3.amazonaws.com/travis-system-info/system-info-2.0.3.gem'
default['travis_system_info']['gem_sha256sum'] = '9d9b7bb90a05610bdda8aee1e8371f24d76e8bc9a75243a0f13cee1e6c7e4058'
default['travis_system_info']['travis_cookbooks_sha'] = 'fffffff'

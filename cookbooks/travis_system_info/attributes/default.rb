include_attribute 'travis_build_environment'

default['travis_system_info']['commands_file'] = '/usr/local/system_info/commands.yml'
default['travis_system_info']['defaults_file'] = '/etc/default/travis-system-info'
default['travis_system_info']['dest_dir'] = '/usr/share/travis'
default['travis_system_info']['gem_url'] = 'https://s3.amazonaws.com/travis-system-info/system-info-2.0.0.gem'
default['travis_system_info']['gem_sha256sum'] = nil
default['travis_system_info']['travis_cookbooks_sha'] = 'fffffff'

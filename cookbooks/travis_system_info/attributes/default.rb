include_attribute 'travis_build_environment'

default['travis_system_info']['commands_file'] = '/usr/local/system_info/commands.yml'
default['travis_system_info']['defaults_file'] = '/etc/default/travis-system-info'
default['travis_system_info']['dest_dir'] = '/usr/share/travis'
default['travis_system_info']['gem_url'] = 'https://s3.amazonaws.com/travis-system-info/system-info-2.0.1.gem'
default['travis_system_info']['gem_sha256sum'] = 'd74319bcfdcc9d2912c3121c66a7c8dc360664a9995b46a4c03b5fbb1e63665f'
default['travis_system_info']['travis_cookbooks_sha'] = 'fffffff'

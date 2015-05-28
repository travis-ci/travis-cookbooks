default['travis_build_environment']['user'] = 'travis'
default['travis_build_environment']['group'] = 'travis'
default['travis_build_environment']['home'] = '/home/travis'
default['travis_build_environment']['hosts'] = {}
default['travis_build_environment']['update_hosts'] = true
default['travis_build_environment']['builds_volume_size'] = '350m'
default['travis_build_environment']['use_tmpfs_for_builds'] = true
default['travis_build_environment']['installation_suffix'] = 'org'
default['travis_build_environment']['apt']['timeout'] = 10
default['travis_build_environment']['apt']['retries'] = 2
default['travis_build_environment']['arch'] = 'i386'
if kernel['machine'] =~ /x86_64/
  default['travis_build_environment']['arch'] = 'amd64'
end

default['java']['default_version'] = ''

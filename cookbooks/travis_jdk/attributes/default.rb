config = default['travis_jdk']

config['versions'] = %w{
  oraclejdk10
  oraclejdk11
  openjdk9
  openjdk10
  openjdk11
}
config['default'] = 'openjdk10'

default['travis_jdk']['install-jdk.sh_path'] = '/usr/local/bin/install-jdk.sh'

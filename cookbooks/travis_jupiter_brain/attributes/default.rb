# frozen_string_literal: true

# Default Attributes
#

# custom haproxy defaults
default['haproxy']['default_timeouts']['client'] = '200s'
default['haproxy']['default_timeouts']['server'] = '200s'

# jupiter brain defaults
default['travis_jupiter_brain']['base_url'] = 'https://jupiter-brain-artifacts.s3.amazonaws.com/travis-ci/jupiter-brain/%s/build/linux/amd64/jb-server'
default['travis_jupiter_brain']['version'] = 'v0.2.0'
default['travis_jupiter_brain']['checksum'] = '32514ce40b0dd9c939ea44214314cac5bbaee454959f342b1e96204fb90970e3'

default['travis_jupiter_brain']['instances'] = [
  {
    'service_name' => 'jupiter-brain',
    'blue_green' => false
  }
  # {
  #   'service_name' => 'jb-bg-example',
  #   'blue_green' => true,
  #   'frontend_bind' => '0.0.0.0:8081',
  #   'blue_addr' => '127.0.0.1:8082',
  #   'green_addr' => '127.0.0.1:8083',
  #   'environment' => {
  #     'JUPITER_BRAIN_AUTH_TOKEN' => 'abcd1234'
  #   }
  # }
]

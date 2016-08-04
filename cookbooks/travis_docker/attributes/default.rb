default['travis_docker']['version'] = '1.10.3-0~trusty'
default['travis_docker']['users'] = %w(travis)
default['travis_docker']['compose']['url'] = 'https://github.com/docker/compose/releases/download/1.6.2/docker-compose-Linux-x86_64'
default['travis_docker']['compose']['sha256sum'] = '7c453a3e52fb97bba34cf404f7f7e7913c86e2322d612e00c71bd1588587c91e'
default['travis_docker']['update_grub'] = true

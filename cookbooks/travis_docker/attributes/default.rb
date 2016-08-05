default['travis_docker']['version'] = '1.10.3-0~trusty'
default['travis_docker']['users'] = %w(travis)
default['travis_docker']['compose']['url'] = 'https://github.com/docker/compose/releases/download/1.6.2/docker-compose-Linux-x86_64'
default['travis_docker']['compose']['sha256sum'] = '7c453a3e52fb97bba34cf404f7f7e7913c86e2322d612e00c71bd1588587c91e'
default['travis_docker']['update_grub'] = true
default['travis_docker']['binary']['url'] = 'https://get.docker.com/builds/Linux/x86_64/docker-1.12.0.tgz'
default['travis_docker']['binary']['version'] = '1.12.0'
default['travis_docker']['binary']['checksum'] = '3dd07f65ea4a7b4c8829f311ab0213bca9ac551b5b24706f3e79a97e22097f8b'
default['travis_docker']['binary']['has_binaries'] = %w(
  docker
  docker-containerd
  docker-containerd-ctr
  docker-containerd-shim
  docker-proxy
  docker-runc
  dockerd
)

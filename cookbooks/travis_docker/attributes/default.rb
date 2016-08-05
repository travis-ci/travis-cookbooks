default['travis_docker']['version'] = '1.12.0-0~trusty'
default['travis_docker']['users'] = %w(travis)
default['travis_docker']['compose']['url'] = 'https://github.com/docker/compose/releases/download/1.8.0/docker-compose-Linux-x86_64'
default['travis_docker']['compose']['sha256sum'] = 'ebc6ab9ed9c971af7efec074cff7752593559496d0d5f7afb6bfd0e0310961ff'
default['travis_docker']['update_grub'] = true
default['travis_docker']['binary']['url'] = 'https://get.docker.com/builds/Linux/x86_64/docker-1.12.0.tgz'
default['travis_docker']['binary']['version'] = '1.12.0'
default['travis_docker']['binary']['checksum'] = '3dd07f65ea4a7b4c8829f311ab0213bca9ac551b5b24706f3e79a97e22097f8b'
default['travis_docker']['binary']['binaries'] = %w(
  docker
  docker-containerd
  docker-containerd-ctr
  docker-containerd-shim
  docker-proxy
  docker-runc
  dockerd
)

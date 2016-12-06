default['travis_docker']['version'] = '1.12.3-0~trusty'
default['travis_docker']['users'] = %w(travis)
default['travis_docker']['compose']['url'] = 'https://github.com/docker/compose/releases/download/1.8.1/docker-compose-Linux-x86_64'
default['travis_docker']['compose']['sha256sum'] = 'd9c19bfd39ccd8bf7168c2afefb6a2cbd77d299c4d61531a220f6803ec6b701a'
default['travis_docker']['update_grub'] = true
default['travis_docker']['binary']['url'] = 'https://get.docker.com/builds/Linux/x86_64/docker-1.12.3.tgz'
default['travis_docker']['binary']['version'] = '1.12.3'
default['travis_docker']['binary']['checksum'] = '626601deb41d9706ac98da23f673af6c0d4631c4d194a677a9a1a07d7219fa0f'
default['travis_docker']['binary']['binaries'] = %w(
  docker
  docker-containerd
  docker-containerd-ctr
  docker-containerd-shim
  docker-proxy
  docker-runc
  dockerd
)

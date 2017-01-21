default['travis_docker']['version'] = '1.12.6-0~ubuntu-trusty'
default['travis_docker']['users'] = %w(travis)
default['travis_docker']['compose']['url'] = 'https://github.com/docker/compose/releases/download/1.9.0/docker-compose-Linux-x86_64'
default['travis_docker']['compose']['sha256sum'] = 'eeca988428d29534fecdff2768fa2e8c293b812b1c77da8ab5daf7f441c92e5b'
default['travis_docker']['update_grub'] = true
default['travis_docker']['binary']['url'] = 'https://get.docker.com/builds/Linux/x86_64/docker-1.12.6.tgz'
default['travis_docker']['binary']['version'] = '1.12.6'
default['travis_docker']['binary']['checksum'] = 'cadc6025c841e034506703a06cf54204e51d0cadfae4bae62628ac648d82efdd'
default['travis_docker']['binary']['binaries'] = %w(
  docker
  docker-containerd
  docker-containerd-ctr
  docker-containerd-shim
  docker-proxy
  docker-runc
  dockerd
)

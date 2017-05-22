default['travis_docker']['version'] = '17.03.1~ce-0~ubuntu-trusty'
default['travis_docker']['users'] = %w(travis)
default['travis_docker']['compose']['url'] = 'https://github.com/docker/compose/releases/download/1.13.0/docker-compose-Linux-x86_64'
default['travis_docker']['compose']['sha256sum'] = '0d8af4d3336b0b41361c06ff213be5c42e2247beb746dbc597803e862af127e8'
default['travis_docker']['update_grub'] = true
default['travis_docker']['binary']['url'] = 'https://download.docker.com/linux/static/stable/x86_64/docker-17.03.1-ce.tgz'
default['travis_docker']['binary']['version'] = '17.03.1-ce'
default['travis_docker']['binary']['checksum'] = '3e070e7b34e99cf631f44d0ff5cf9a127c0b8af5c53dfc3e1fce4f9615fbf603'
default['travis_docker']['binary']['binaries'] = %w(
  docker
  docker-containerd
  docker-containerd-ctr
  docker-containerd-shim
  docker-init
  docker-proxy
  docker-runc
  dockerd
)

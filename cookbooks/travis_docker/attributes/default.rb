# frozen_string_literal: true

# Note: The docker-ce package version strings have been known to diverge between
# Trusty and Xenial. When updating check the version exists in both of:
# https://download.docker.com/linux/ubuntu/dists/trusty/stable/binary-amd64/Packages
# https://download.docker.com/linux/ubuntu/dists/xenial/stable/binary-amd64/Packages
default['travis_docker']['version'] = '18.06.0~ce~3-0~ubuntu'
default['travis_docker']['users'] = %w[travis]
default['travis_docker']['compose']['url'] = 'https://github.com/docker/compose/releases/download/1.23.1/docker-compose-Linux-x86_64'
default['travis_docker']['compose']['sha256sum'] = 'c176543737b8aea762022245f0f4d58781d3cb1b072bc14f3f8e5bb96f90f1a2'
default['travis_docker']['update_grub'] = true
default['travis_docker']['binary']['version'] = '18.06.1-ce'
default['travis_docker']['binary']['checksum'] = '83be159cf0657df9e1a1a4a127d181725a982714a983b2bdcc0621244df93687'
machine = node['kernel']['machine']
version = node['travis_docker']['binary']['version']
default['travis_docker']['binary']['url'] = "https://download.docker.com/linux/static/stable/#{machine}/docker-#{version}.tgz"
if node['kernel']['machine'] == 'ppc64le'
  default['travis_docker']['binary']['checksum'] = '479083ac0b2bae839782ea53870809b8590f440db5f0bdf1294eac95e1a2ec3b'
end
default['travis_docker']['binary']['binaries'] = %w[
  docker
  docker-containerd
  docker-containerd-ctr
  docker-containerd-shim
  docker-init
  docker-proxy
  docker-runc
  dockerd
]

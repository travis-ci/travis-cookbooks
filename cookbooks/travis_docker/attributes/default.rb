# frozen_string_literal: true

# Note: The docker-ce package version strings have been known to diverge between
# Trusty and Xenial. When updating check the version exists in both of:
# https://download.docker.com/linux/ubuntu/dists/trusty/stable/binary-amd64/Packages
# https://download.docker.com/linux/ubuntu/dists/xenial/stable/binary-amd64/Packages
default['travis_docker']['version'] = '18.03.1~ce-0~ubuntu'
default['travis_docker']['users'] = %w[travis]
default['travis_docker']['compose']['url'] = 'https://github.com/docker/compose/releases/download/1.17.1/docker-compose-Linux-x86_64'
default['travis_docker']['compose']['sha256sum'] = 'db0a7b79d195dc021461d5628a8d53eeb2e556d2548b764770fccabb0a319dd8'
default['travis_docker']['update_grub'] = true
default['travis_docker']['binary']['version'] = '18.03.1-ce'
default['travis_docker']['binary']['checksum'] = '0e245c42de8a21799ab11179a4fce43b494ce173a8a2d6567ea6825d6c5265aa'
machine = node['kernel']['machine']
version = node['travis_docker']['binary']['version']
default['travis_docker']['binary']['url'] = "https://download.docker.com/linux/static/stable/#{machine}/docker-#{version}.tgz"
if node['kernel']['machine'] == 'ppc64le'
  default['travis_docker']['binary']['checksum'] = '7633a67fa2be7d37700c6809968cd3692a8e0924cf05b4dd9f51c56bdbbdab10'
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

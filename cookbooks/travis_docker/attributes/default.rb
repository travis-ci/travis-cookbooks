# Note: The docker-ce package version strings have been known to diverge between
# Trusty and Xenial. When updating check the version exists in both of:
# https://download.docker.com/linux/ubuntu/dists/trusty/stable/binary-amd64/Packages
# https://download.docker.com/linux/ubuntu/dists/xenial/stable/binary-amd64/Packages
default['travis_docker']['version'] = '17.12.1~ce-0~ubuntu'
default['travis_docker']['users'] = %w[travis]
default['travis_docker']['compose']['url'] = 'https://github.com/docker/compose/releases/download/1.17.1/docker-compose-Linux-x86_64'
default['travis_docker']['compose']['sha256sum'] = 'db0a7b79d195dc021461d5628a8d53eeb2e556d2548b764770fccabb0a319dd8'
default['travis_docker']['update_grub'] = true
default['travis_docker']['binary']['url'] = "https://download.docker.com/linux/static/stable/#{node['kernel']['machine']}/docker-17.12.1-ce.tgz"
default['travis_docker']['binary']['version'] = '17.12.1-ce'
default['travis_docker']['binary']['checksum'] = 'f1722346f98463e44018dc9f1ce5c56c4b203d4237ecc8f4b4fbc1eac1693f18'
if node['kernel']['machine'] == 'ppc64le'
  default['travis_docker']['binary']['checksum'] = 'f00d4cefd392893241e5ae3be292ade0e9076cbba6fde56e731ae5002558b82a'
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

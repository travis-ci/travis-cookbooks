# Note: The docker-ce package version strings have been known to diverge between
# Trusty and Xenial. When updating check the version exists in both of:
# https://download.docker.com/linux/ubuntu/dists/trusty/stable/binary-amd64/Packages
# https://download.docker.com/linux/ubuntu/dists/xenial/stable/binary-amd64/Packages
default['travis_docker']['version'] = '17.06.1~ce-0~ubuntu'
default['travis_docker']['ppc64le']['apt']['url'] = 'http://ftp.unicamp.br/pub/ppc64el/ubuntu/16_04/docker-17.06.1-ce-ppc64el/'
default['travis_docker']['users'] = %w[travis]
default['travis_docker']['compose']['url'] = 'https://github.com/docker/compose/releases/download/1.15.0/docker-compose-Linux-x86_64'
default['travis_docker']['compose']['sha256sum'] = 'acfa66dba77dac9635ff9b195ccea81768eb009ce9c9f1181c000eb95effb963'
default['travis_docker']['update_grub'] = true
default['travis_docker']['binary']['url'] = 'https://download.docker.com/linux/static/stable/x86_64/docker-17.06.1-ce.tgz'
default['travis_docker']['binary']['version'] = '17.06.1-ce'
default['travis_docker']['binary']['checksum'] = 'e35fe12806eadbb7eb8aa63e3dfb531bda5f901cd2c14ac9cdcd54df6caed697'
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

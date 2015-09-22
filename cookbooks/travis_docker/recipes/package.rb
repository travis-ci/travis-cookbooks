apt_repository 'docker' do
  uri 'https://apt.dockerproject.org/repo'
  distribution 'ubuntu-trusty'
  components ['main']
  key 'https://apt.dockerproject.org/gpg'
  action :add
end

package %W(
  linux-generic-lts-vivid
  lxc
)

package 'docker-engine' do
  version node['travis_docker']['version']
end

# frozen_string_literal: true

apt_repository 'mercurial' do
  uri 'ppa:mercurial-ppa/releases'
  distribution node['lsb']['codename']
  keyserver 'hkp://ha.pool.sks-keyservers.net'
  retries 2
  retry_delay 30
  only_if { node['travis_build_environment']['mercurial_install_type'] == 'ppa' }
  not_if { node['kernel']['machine'] == 'ppc64le' }
end

package 'mercurial' do
  version node['travis_build_environment']['mercurial_version']
  action %i[install upgrade]
  only_if { node['travis_build_environment']['mercurial_install_type'] == 'ppa' }
  not_if { node['kernel']['machine'] == 'ppc64le' }
end

execute %W[
  pip install
  "mercurial==#{node['travis_build_environment']['mercurial_version'].sub(/~.*/, '')}"
].join(' ') do
  user 'root'
  group 'root'
  only_if { node['travis_build_environment']['mercurial_install_type'] == 'pip' }
end

package 'python-docutils' do
  action %i[install upgrade]
  only_if { node['kernel']['machine'] == 'ppc64le' }
end

ark 'mercurial' do
  url node['travis_build_environment']['mercurial_url']
  version node['travis_build_environment']['mercurial_ppc_version']
  make_opts ['all']
  action :install_with_make
  only_if { node['travis_build_environment']['mercurial_install_type'] == 'src' }
  only_if { node['kernel']['machine'] == 'ppc64le' }
end

# frozen_string_literal: true

apt_repository 'mercurial' do
  uri 'ppa:mercurial-ppa/releases'
  keyserver 'hkp://ha.pool.sks-keyservers.net'
  retries 2
  retry_delay 30
  only_if { node['travis_build_environment']['mercurial_install_type'] == 'ppa' }
  not_if { node['kernel']['machine'] == 'ppc64le' }
end

package 'mercurial' do
  version node['travis_build_environment']['mercurial_version']
  action %i(install upgrade)
  only_if { node['travis_build_environment']['mercurial_install_type'] == 'ppa' }
  not_if { node['kernel']['machine'] == 'ppc64le' }
end

execute %W(
  pip install
  "mercurial==#{node['travis_build_environment']['mercurial_version'].sub(/~.*/, '')}"
).join(' ') do
  user 'root'
  group 'root'
  only_if { node['travis_build_environment']['mercurial_install_type'] == 'pip' }
end

execute %W(
  apt install -y python3-mercurial
) do
  user 'root'
  group 'root'
  only_if { node['travis_build_environment']['mercurial_install_type'] == 'apt' }
end

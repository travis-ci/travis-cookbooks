apt_repository 'mercurial' do
  uri 'ppa:mercurial-ppa/releases'
  distribution node['lsb']['codename']
  keyserver 'hkp://ha.pool.sks-keyservers.net'
  retries 2
  retry_delay 30
  only_if do
    node['travis_build_environment']['mercurial_install_type'] == 'ppa'
  end
end

package 'mercurial' do
  version node['travis_build_environment']['mercurial_version']
  action %i[install upgrade]
  only_if do
    node['travis_build_environment']['mercurial_install_type'] == 'ppa'
  end
end

execute %W[
  pip install
  "mercurial==#{node['travis_build_environment']['mercurial_version'].sub(/~.*/, '')}"
].join(' ') do
  user 'root'
  group 'root'
  only_if do
    node['travis_build_environment']['mercurial_install_type'] == 'pip'
  end
end
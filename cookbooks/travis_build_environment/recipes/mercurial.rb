apt_repository 'mercurial' do
  uri 'ppa:mercurial-ppa/releases'
  distribution node['lsb']['codename']
  keyserver 'hkp://ha.pool.sks-keyservers.net'
  retries 2
  retry_delay 30
end

package %w(mercurial-common mercurial) do
  action %i(install upgrade)
end

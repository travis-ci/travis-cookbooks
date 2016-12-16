apt_repository 'hvr-ghc' do
  uri 'http://ppa.launchpad.net/hvr/ghc/ubuntu'
  distribution node['lsb']['codename']
  components ['main']
  key 'F6F88286'
  keyserver 'hkp://ha.pool.sks-keyservers.net'
  retries 2
  retry_delay 30
  action :add
end

package Array(
  node['travis_build_environment']['haskell_ghc_versions']
).map { |v| "ghc-#{v}" }

package Array(
  node['travis_build_environment']['haskell_cabal_versions']
).map { |v| "cabal-install-#{v}" }

template '/etc/profile.d/travis-haskell.sh' do
  source 'travis-haskell.sh.erb'
  owner 'root'
  group 'root'
  mode 0o755
  variables(
    cabal_root: '/opt/cabal',
    default_cabal: node['travis_build_environment']['haskell_default_cabal'],
    default_ghc: node['travis_build_environment']['haskell_default_ghc'],
    ghc_root: '/opt/ghc'
  )
end

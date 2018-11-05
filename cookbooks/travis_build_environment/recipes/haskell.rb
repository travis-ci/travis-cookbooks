# frozen_string_literal: true

apt_repository 'hvr-ghc' do
  uri 'ppa:hvr/ghc'
  action :add
end

haskell = node['travis_build_environment']['haskell']

package Array(
  haskell['ghc_versions']
).map { |v| "ghc-#{v}" }

package Array(
  haskell['cabal_versions']
).map { |v| "cabal-install-#{v}" }

if haskell.key?('default_cabal')
  default_cabal = haskell['default_cabal']
else
  default_cabal = haskell['cabal_versions'].max
end

if haskell.key?('default_ghc')
  default_ghc = haskell['default_ghc']
else
  default_ghc = haskell['ghc_versions'].max
end

template '/etc/profile.d/travis-haskell.sh' do
  source 'travis-haskell.sh.erb'
  owner 'root'
  group 'root'
  mode 0o755
  variables(
    cabal_root: '/opt/cabal',
    default_cabal: default_cabal,
    default_ghc: default_ghc,
    ghc_root: '/opt/ghc'
  )
end

apt_repository 'hvr-ghc' do
  action :remove
  not_if { haskell['keep_repo'] }
end

default['travis_php']['multi']['packages'] = %w(
  autoconf
  bison
  build-essential
  libbison-dev
  libfreetype6-dev
  libreadline6-dev
)
default['travis_php']['multi']['prerequisite_recipes'] = %w(
  travis_phpenv
)
default['travis_php']['multi']['postrequisite_recipes'] = %w(
  travis_php::hhvm
  travis_php::hhvm-nightly
)
multi_versions = %w(
  5.4.45
  5.5.30
  5.6.15
)
default['travis_php']['multi']['versions'] = multi_versions
default['travis_php']['multi']['aliases'] = {
  '5.4' => '5.4.45',
  '5.5' => '5.5.30',
  '5.6' => '5.6.15'
}
default['travis_php']['hhvm']['package']['name'] = 'hhvm'

default['travis_php']['composer']['github_oauth_token'] = nil

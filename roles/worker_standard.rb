#
# Role defintion based on https://github.com/travis-ci/travis-images/blob/master/templates/worker.standard.yml
#
name 'worker_standard'
description 'Travis Standard Worker for Linux'
default_attributes(
  'gimme' =>
      {
        'default_version' => '1.4.1',
        'versions' => ['1.4.1']
      },
  'rvm' =>
      {
        'default' => '1.9.3',
        'gems' => %w(bundler rake),
        'rubies' => [{ 'name' => '1.9.3' }]
      },
  'travis_build_environment' =>
      {
        'use_tmpfs_for_builds' => false,
      }
)
run_list(
  #
  # Travis environment + build toolchain
  #
  'recipe[travis_build_environment]',
  'recipe[apt]',
  'recipe[build-essential]',
  'recipe[clang::tarball]',
  'recipe[gimme]',
  'recipe[networking_basic]',
  'recipe[openssl]',
  'recipe[sysctl]',
  'recipe[git::ppa]',
  'recipe[mercurial]',
  'recipe[bazaar]',
  'recipe[subversion]',
  'recipe[scons]',
  'recipe[unarchivers]',
  'recipe[md5deep]',
  'recipe[jq]',
  #
  # additional libraries needed to run headless WebKit,
  # build parsers, for ossp-uuid to work and so on
  #
  'recipe[libqt4]',
  'recipe[libgdbm]',
  'recipe[libncurses]',
  'recipe[libossp-uuid]',
  'recipe[libffi]',
  'recipe[ragel]',
  'recipe[imagemagick]',
  'recipe[mingw32]',
  'recipe[libevent]',
  #
  # JDK and related build toolchain
  #
  'recipe[java]',
  'recipe[ant]',
  'recipe[maven]',
  #
  # Needs to be installed before RVM
  #
  'recipe[sqlite]',
  #
  # Ruby via RVM (default Debian installations are secure at the cost of
  # being unusable without PATH tweaking, for our VMs we can just go with RVM.
  # This includes rubygems, bundler and rake.
  #
  'recipe[rvm]',
  'recipe[rvm::multi]',
  #
  # Python and pip
  #
  'recipe[python]',
  'recipe[python::devshm]',
  'recipe[python::pip]',
  #
  # Node.js
  #
  'recipe[nodejs::multi]',
  #
  # Data stores
  #
  'recipe[mysql::server_on_ramfs]',
  'recipe[postgresql]',
  'recipe[redis]',
  'recipe[riak]',
  'recipe[mongodb]',
  'recipe[couchdb::ppa]',
  'recipe[memcached]',
  'recipe[neo4j-server::tarball]',
  'recipe[cassandra::tarball]',
  #
  # Messaging
  #
  'recipe[rabbitmq::with_management_plugin]',
  'recipe[zeromq::ppa]',
  #
  # Search
  #
  'recipe[elasticsearch]',
  'recipe[sphinx::all]',
  #
  # Headless WebKit, browsers, Selenium toolchain, etc
  #
  'recipe[xserver]',
  'recipe[firefox::tarball]',
  'recipe[chromium]',
  'recipe[phantomjs::tarball]',
  #
  # Debugging & support
  #
  'recipe[emacs::nox]',
  'recipe[vim]',
  'recipe[sweeper]'
)

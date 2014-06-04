#
# Role defintion based on https://github.com/travis-ci/travis-images/blob/master/templates/worker.standard.yml
# May eventually be merged with worker_standard, if the run_list is made OS-agnostic.
#
name 'worker_windows'
description 'Experimental Travis Standard Worker for Windows'
default_attributes(
  'golang' =>
    { 'multi' =>
      {
        'aliases' => [],
        'default_version' => 'go1.2',
        'versions' => ['go1.2']
      }
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
      'user' => 'vagrant',      # Note - vagrant only!
    }
)
run_list(
  #
  # Travis environment + build toolchain
  #
  'recipe[travis_build_environment::common]',

  #
  # Quick and dirty Windows setup, should be split into proper community cookbooks
  #
  'recipe[travis_build_environment::windows]'
)

default[:zeromq] = {
  :package => {
    :url   => "http://files.travis-ci.org/packages/deb/zeromq/zeromq_2.1.10+fpm0_#{node.travis_build_environment.arch}.deb",
    :user  => node.travis_build_environment.user,
    :group => node.travis_build_environment.group
  }
}

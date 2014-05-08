include_recipe "php::hhvm"

phpenv_path = "#{node.travis_build_environment.home}/.phpenv"

link "#{phpenv_path}/versions/hhvm-nightly" do
  to "#{phpenv_path}/versions/hhvm"
end

directory "#{phpenv_path}/rbenv.d/exec" do
  owner     node.travis_build_environment.user
  group     node.travis_build_environment.group
  recursive true
end

template "#{phpenv_path}/rbenv.d/exec/hhvm-switcher.bash" do
  owner  node.travis_build_environment.user
  group  node.travis_build_environment.group
  source "hhvm-switcher.bash.erb"
  variables(
    :phpenv_path => phpenv_path
  )
end

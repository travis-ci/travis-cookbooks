include_recipe "hhvm"
include_recipe "phpenv"

phpenv_path = "#{node.travis_build_environment.home}/.phpenv"
hhvm_path   = "#{phpenv_path}/versions/hhvm-#{node["hhvm"]["package"]["version"]}"

directory hhvm_path do
  owner     node.travis_build_environment.user
  group     node.travis_build_environment.group
  action    :create
end

directory "#{hhvm_path}/bin" do
  owner     node.travis_build_environment.user
  group     node.travis_build_environment.group
  action    :create
end

link "#{hhvm_path}/bin/php" do
  to "/usr/bin/hhvm"
end

# Alias
link "#{phpenv_path}/versions/hhvm" do
  to hhvm_path
end

# Install composer
remote_file "#{hhvm_path}/bin/composer" do
  source "http://getcomposer.org/composer.phar"
  owner  node.travis_build_environment.user
  group  node.travis_build_environment.group
  mode   0755
end

# Install phpunit
remote_file "#{hhvm_path}/bin/phpunit" do
  source "https://phar.phpunit.de/phpunit.phar"
  owner  node.travis_build_environment.user
  group  node.travis_build_environment.group
  mode   0755
end

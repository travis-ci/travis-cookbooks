include_recipe "bison"
include_recipe "libreadline"

include_recipe "phpenv"
include_recipe "phpbuild"

phpbuild_path = "#{node.travis_build_environment.home}/.php-build"
phpenv_path   = "#{node.travis_build_environment.home}/.phpenv"

node.php.multi.versions.each do |php_version|
  phpbuild_build "#{phpenv_path}/versions" do
    version   php_version
    owner     node.travis_build_environment.user
    group     node.travis_build_environment.group

    action  :create
  end

  link "#{phpenv_path}/versions/#{php_version}/bin/php-fpm" do
    to "#{phpenv_path}/versions/#{php_version}/sbin/php-fpm"
  end
end

node.php.multi.aliases.each do |short_version, target_version|
  link "#{phpenv_path}/versions/#{short_version}" do
    to "#{phpenv_path}/versions/#{target_version}"
  end
end

include_recipe "php::extensions"
include_recipe "php::hhvm"
include_recipe "php::hhvm-nightly"
include_recipe "composer"

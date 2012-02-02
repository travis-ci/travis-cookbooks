include_recipe "phpenv"
include_recipe "phpbuild"

phpbuild_path = "#{node.travis_build_environment.home}/.php-build"
phpenv_path   = "#{node.travis_build_environment.home}/.phpenv"

node.php.multi.versions.each do |php_version|

  phpbuild_build "#{phpenv_path}/versions" do
    version php_version
    owner   node.travis_build_environment.user
    group   node.travis_build_environment.group

    action  :create
  end

end

node.php.multi.aliases.each do |short_version, target_version|
  link "#{phpenv_path}/versions/#{short_version}" do
    to "#{phpenv_path}/versions/#{target_version}"
  end
end

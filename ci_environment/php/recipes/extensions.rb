include_recipe "phpenv"
include_recipe "phpbuild"

node.php.multi.extensions.each do |php_extension, options|
  php_pecl php_extension do
    channel         options['channel']
    versions        options['versions'] || node.php.multi.versions
    before_recipes  options['before_recipes']
    before_packages options['before_packages']
    before_script   options['before_script']
    script          options['script']
    owner           node.travis_build_environment.user
    group           node.travis_build_environment.group

    action          :install
  end
end

node.php.multi.versions.each do |php_version|
  bash "disable preinstalled PECL extensions for PHP #{php_version}" do
    user        node.travis_build_environment.user
    group       node.travis_build_environment.group
    environment Hash["HOME" => node.travis_build_environment.home]
    code        "sed -i '/^extension=/d' $HOME/.phpenv/versions/#{php_version}/etc/php.ini"
  end
end

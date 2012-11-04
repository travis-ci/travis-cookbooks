include_recipe "phpenv"
include_recipe "phpbuild"

node.php.multi.extensions.each do |php_extension, options|
  php_pecl php_extension do
    channel         options['channel']
    versions        options['versions'] || node.php.multi.versions
    before_packages options['before_packages']
    before_script   options['before_script']
    owner           node.travis_build_environment.user
    group           node.travis_build_environment.group

    action          :install
  end
end

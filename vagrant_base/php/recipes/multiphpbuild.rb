include_recipe "phpbuild"
include_recipe "phpenv"

phpbuild_path = "#{node.phpbuild.home}/.php-build"
phpenv_path = "#{node.phpenv.home}/.phpenv"

node.php.multi.versions.each do |php_version|

  phpbuild_build "#{phpenv_path}/versions" do
    version php_version
    owner "vagrant"
    group "vagrant"

    action :create
  end

  #pyrus_bin = "#{phpfarm_path}/inst/bin/pyrus-#{php_version}"
  #phpunit_bin = "#{phpfarm_path}/inst/php-#{php_version}/bin/phpunit"
  #bash "install phpunit" do
    #user "vagrant"
    #group "vagrant"
    #environment Hash["HOME" => node.phpfarm.home]
    #cwd phpfarm_path
    #code <<-EOF
    #. #{pyrus_bin} channel-discover pear.phpunit.de
    #. #{pyrus_bin} channel-discover pear.symfony-project.com
    #. #{pyrus_bin} install phpunit/PHPUnit
    #EOF
    #not_if "test -f #{phpunit_bin}"
  #end

end

node.php.multi.aliases.each do |short_version, target_version|
  link "#{phpenv_path}/versions/php-#{short_version}" do
    to "#{phpenv_path}/versions/php-#{target_version}"
  end
end

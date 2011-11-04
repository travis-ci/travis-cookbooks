include_recipe "phpfarm"
include_recipe "phpenv"

phpfarm_path = "#{node.phpfarm.home}/.phpfarm"
phpenv_path = "#{node.phpenv.home}/.phpenv"

# symlink php versions installed by phpfarm into phpenv
link "#{phpenv_path}/versions" do
  to "#{phpfarm_path}/inst"
end

node.php.multi.versions.each do |php_version|

  phpfarm_compile php_version do
    owner "vagrant"
    group "vagrant"

    action :create
  end

  pyrus_bin = "#{phpfarm_path}/inst/bin/pyrus-#{php_version}"
  phpunit_bin = "#{phpfarm_path}/inst/php-#{php_version}/bin/phpunit"
  bash "install phpunit" do
    user "vagrant"
    group "vagrant"
    environment Hash["HOME" => node.phpfarm.home]
    cwd phpfarm_path
    code <<-EOF
    . #{pyrus_bin} channel-discover pear.phpunit.de
    . #{pyrus_bin} channel-discover pear.symfony-project.com
    . #{pyrus_bin} install phpunit/PHPUnit
    EOF
    not_if "test -f #{phpunit_bin}"
  end

end

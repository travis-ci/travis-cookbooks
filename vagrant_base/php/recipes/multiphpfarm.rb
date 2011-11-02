node.php.multi.phps.each do |php_version|
  phpfarm_compile php_version do
    owner "vagrant"
    group "vagrant"

    action :create
  end

  pyrus_bin = "#{node.phpfarm.path}/inst/bin/pyrus-#{php_version}"
  phpunit_bin = "#{node.phpfarm.path}/inst/php-#{php_version}/bin/phpunit"
  bash "install phpunit" do
    user "vagrant"
    group "vagrant"
    environment Hash["HOME" => "/home/vagrant"]
    cwd node.phpfarm.path
    code <<-EOF
    . #{pyrus_bin} channel-discover pear.phpunit.de
    . #{pyrus_bin} channel-discover pear.symfony-project.com
    . #{pyrus_bin} install phpunit/PHPUnit
    EOF
    not_if "test -f #{phpunit_bin}"
  end

end

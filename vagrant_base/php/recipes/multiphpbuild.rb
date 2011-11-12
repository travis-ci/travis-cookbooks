include_recipe "phpenv"
include_recipe "phpbuild"

phpbuild_path = "#{node.phpbuild.home}/.php-build"
phpenv_path = "#{node.phpenv.home}/.phpenv"

node.php.multi.versions.each do |php_version|

  phpbuild_build "#{phpenv_path}/versions" do
    version php_version
    owner "vagrant"
    group "vagrant"

    action :create
  end

end

node.php.multi.aliases.each do |short_version, target_version|
  link "#{phpenv_path}/versions/#{short_version}" do
    to "#{phpenv_path}/versions/#{target_version}"
  end
end

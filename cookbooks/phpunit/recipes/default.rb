include_recipe "php::multi"

phpenv_path = File.join(node.travis_build_environment.home, ".phpenv")

node[:php][:multi][:versions].each do |php_version|
  bin_path = "#{phpenv_path}/versions/#{php_version}/bin"
  remote_file "#{bin_path}/phpunit" do
    source "https://phar.phpunit.de/phpunit.phar"
    owner  node.travis_build_environment.user
    group  node.travis_build_environment.group
    mode   0755
    not_if { php_version.start_with?("5.2") }
  end
end

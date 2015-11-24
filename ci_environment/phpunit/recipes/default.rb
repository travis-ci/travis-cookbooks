include_recipe "php::multi"

phpenv_path = File.join(node.travis_build_environment.home, ".phpenv")

node[:php][:multi][:versions].each do |php_version|
  bin_path = "#{phpenv_path}/versions/#{php_version}/bin"

  source_url = 'https://phar.phpunit.de/phpunit.phar'
  if php_version.to_s < '5.6'
    source_url = 'https://phar.phpunit.de/phpunit-old.phar'
  end

  remote_file "#{bin_path}/phpunit" do
    source source_url
    owner  node.travis_build_environment.user
    group  node.travis_build_environment.group
    mode   0755
    not_if { php_version.start_with?("5.2") }
  end
end

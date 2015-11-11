include_recipe 'travis_php::multi'

phpenv_path = File.join(node['travis_build_environment']['home'], '.phpenv')

node['travis_php']['multi']['versions'].each do |php_version|
  remote_file "#{phpenv_path}/versions/#{php_version}/bin/phpunit" do
    source 'https://phar.phpunit.de/phpunit.phar'
    owner node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    mode 0755
    not_if { php_version =~ /^5\.2/ }
  end
end

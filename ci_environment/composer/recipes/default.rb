include_recipe "php::multi"

phpenv_path   = File.join(node.travis_build_environment.home, ".phpenv")
composer_path = File.join(node.travis_build_environment.home, ".composer")

node[:php][:multi][:versions].each do |php_version|
  bin_path = "#{phpenv_path}/versions/#{php_version}/bin"
  remote_file "#{bin_path}/composer.phar" do
    source "http://getcomposer.org/composer.phar"
    owner  node.travis_build_environment.user
    group  node.travis_build_environment.group
    mode   "0644"
  end

  template "#{bin_path}/composer" do
    owner  node.travis_build_environment.user
    group  node.travis_build_environment.group
    mode   "0755"
    source "composer.erb"
    variables(:phpbin_path => bin_path)
  end
end

directory composer_path do
  owner  node.travis_build_environment.user
  group  node.travis_build_environment.group
  mode 0755
  action :create
end

template "#{composer_path}/config.json" do
  owner  node.travis_build_environment.user
  group  node.travis_build_environment.group
  source "config.json.erb"
  variables(:github_oauth_token => node[:composer][:github_oauth_token])
end

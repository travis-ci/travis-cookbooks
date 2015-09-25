unless Array(node['travis_php']['multi']['prerequisite_recipes']).empty?
  Array(node['travis_php']['multi']['prerequisite_recipes']).each do |recipe_name|
    include_recipe recipe_name
  end
end

phpbuild_path = "#{node['travis_build_environment']['home']}/.php-build"
phpenv_path   = "#{node['travis_build_environment']['home']}/.phpenv"

node['travis_php']['multi']['versions'].each do |php_version|
  travis_phpbuild_build "#{phpenv_path}/versions" do
    version   php_version
    owner     node['travis_build_environment']['user']
    group     node['travis_build_environment']['group']

    action  :create
  end

  link "#{phpenv_path}/versions/#{php_version}/bin/php-fpm" do
    to "#{phpenv_path}/versions/#{php_version}/sbin/php-fpm"
  end
end

node['travis_php']['multi']['aliases'].each do |short_version, target_version|
  link "#{phpenv_path}/versions/#{short_version}" do
    to "#{phpenv_path}/versions/#{target_version}"
  end
end

unless Array(node['travis_php']['multi']['postrequisite_recipes']).empty?
  Array(node['travis_php']['multi']['postrequisite_recipes']).each do |recipe_name|
    include_recipe recipe_name
  end
end

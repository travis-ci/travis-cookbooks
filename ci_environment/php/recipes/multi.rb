include_recipe "bison"
include_recipe "libreadline"

include_recipe "phpenv"
include_recipe "phpbuild"

phpbuild_path = "#{node.travis_build_environment.home}/.php-build"
phpenv_path   = "#{node.travis_build_environment.home}/.phpenv"

node.php.multi.versions.each do |php_version|
  local_archive = ::File.join(
    Chef::Config[:file_cache_path],
    "php-#{php_version}.tar.bz2"
  )

  remote_file local_archive do
    source ::File.join(
      'https://s3.amazonaws.com/travis-php-archives/binaries',
      node['platform'],
      node['platform_version'],
      node['kernel']['machine'],
      ::File.basename(local_archive)
    )
    ignore_failure true
    not_if { ::File.exist?(local_archive) }
  end

  bash "Expand PHP #{php_version} archive" do
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    code "tar -xjf #{local_archive.inspect} --directory /"
    only_if { ::File.exist?(local_archive) }
  end

  phpbuild_build "#{phpenv_path}/versions" do
    version   php_version
    owner     node.travis_build_environment.user
    group     node.travis_build_environment.group
    action  :create
    not_if { ::File.exist?(local_archive) }
  end

  link "#{phpenv_path}/versions/#{php_version}/bin/php-fpm" do
    to "#{phpenv_path}/versions/#{php_version}/sbin/php-fpm"
    not_if do
      ::File.exist?("#{phpenv_path}/versions/#{php_version}/sbin/php-fpm")
    end
  end
end

node.php.multi.aliases.each do |short_version, target_version|
  link "#{phpenv_path}/versions/#{short_version}" do
    to "#{phpenv_path}/versions/#{target_version}"
    not_if do
      ::File.exist?("#{phpenv_path}/versions/#{target_version}")
    end
  end
end

include_recipe "php::extensions"
include_recipe "php::hhvm"
include_recipe "php::hhvm-nightly"
include_recipe "phpunit"
include_recipe "composer"

bash 'set global default php' do
  # NOTE: It is important that this happens *after* the conditional inclusion of
  # the php::hhvm recipe just above so that the default php
  # version is not hhvm.
  code "phpenv global #{node['php']['multi']['default_version']}"
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  flags '-l'
  environment('HOME' => node['travis_build_environment']['home'])
  not_if { Array(node['php']['multi']['versions']).empty? }
end

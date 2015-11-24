# Cookbook Name:: travis_php
# Recipe:: multi
# Copyright 2011-2015, Travis CI GmbH <contact+travis-cookbooks@travis-ci.org>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

unless Array(node['travis_php']['multi']['packages']).empty?
  package Array(node['travis_php']['multi']['packages'])
end

unless Array(node['travis_php']['multi']['prerequisite_recipes']).empty?
  Array(node['travis_php']['multi']['prerequisite_recipes']).each do |recipe_name|
    include_recipe recipe_name
  end
end

phpbuild_path = "#{node['travis_build_environment']['home']}/.php-build"
phpenv_path = "#{node['travis_build_environment']['home']}/.phpenv"

node['travis_php']['multi']['versions'].each do |php_version|
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

  travis_phpbuild_build "#{phpenv_path}/versions" do
    version php_version
    owner node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    action :create
    not_if { ::File.exist?(local_archive) }
  end

  link "#{phpenv_path}/versions/#{php_version}/bin/php-fpm" do
    to "#{phpenv_path}/versions/#{php_version}/sbin/php-fpm"
    not_if do
      ::File.exist?("#{phpenv_path}/versions/#{php_version}/sbin/php-fpm")
    end
  end
end

node['travis_php']['multi']['aliases'].each do |short_version, target_version|
  link "#{phpenv_path}/versions/#{short_version}" do
    to "#{phpenv_path}/versions/#{target_version}"
    not_if do
      ::File.exist?("#{phpenv_path}/versions/#{target_version}")
    end
  end
end

unless Array(node['travis_php']['multi']['postrequisite_recipes']).empty?
  Array(node['travis_php']['multi']['postrequisite_recipes']).each do |recipe_name|
    include_recipe recipe_name
  end
end

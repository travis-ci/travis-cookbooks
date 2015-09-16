#
# Cookbook Name:: google-chrome
# Recipe:: default
# Copyright 2015, Travis CI Development Team <contact@travis-ci.org>

chrome_file = File.join(Chef::Config[:file_cache_path], 'chrome.deb')

# The order in which these 28 packages should be installed is not entirely clear,
# so we install everything at once, so that apt-get can decide
bash "install dependencies" do
  user 'root'
  code "apt-get install #{node['google-chrome']['deps'].join(' ')}"
end

remote_file chrome_file do
  source node['google-chrome']['pkg']['url']
end

dpkg_package "google-chrome-stable" do
  source chrome_file
  action :install
end

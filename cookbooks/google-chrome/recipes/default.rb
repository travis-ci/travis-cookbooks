# Cookbook Name:: google-chrome
# Recipe:: default
# Copyright 2015, Travis CI Development Team <contact@travis-ci.org>

chrome_file = File.join(Chef::Config[:file_cache_path], 'chrome.deb')

package node['google-chrome']['deps']

remote_file chrome_file do
  source node['google-chrome']['pkg']['url']
end

dpkg_package 'google-chrome-stable' do
  source chrome_file
  action :install
end

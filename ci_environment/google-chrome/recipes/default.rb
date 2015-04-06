#
# Cookbook Name:: google-chrome
# Recipe:: default
# Copyright 2015, Travis CI Development Team <contact@travis-ci.org>

chrome_file = File.join(Chef::Config[:file_cache_path], 'chrome.deb')

deps = %w(
  gconf-service
  libasound2
  libcairo2
  libcups2
  libfontconfig1
  libgconf-2-4
  libgdk-pixbuf2.0-0
  libgtk2.0-0
  libnspr4
  libnss3
  libpango1.0-0
  libx11-6
  libxcomposite1
  libxcursor1
  libxdamage1
  libxext6
  libxfixes3
  libxi6
  libxrandr2
  libxrender1
  libxss1
  libxtst6
  libdbusmenu-glib4
  libdbusmenu-gtk4
  libindicator7
  libappindicator1
  libcurl3
  xdg-utils
)

bash "install dependencies" do
  user 'root'
  code "apt-get install #{deps.join(' ')}"
end

remote_file chrome_file do
  source 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
end

dpkg_package "google-chrome-stable" do
  source chrome_file
  action :install
end

#
# Cookbook Name:: package-updates
# Recipe:: default
#
# Copyright 2014, Travis CI GmbH
#
# All rights reserved - Do Not Redistribute
#

node.travis_build_environment.packages.each do |pkg|
  package pkg do
    action :upgrade
  end
end

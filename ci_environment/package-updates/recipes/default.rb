#
# Cookbook Name:: package-updates
# Recipe:: default
#
# Copyright 2014, Travis CI GmbH
#
# All rights reserved - Do Not Redistribute
#

unless Array(node['travis_build_environment']['packages']).empty?
  package Array(node['travis_build_environment']['packages'])
end

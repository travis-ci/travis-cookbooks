#
# Cookbook Name:: package-updates
# Recipe:: default
#
# Copyright 2014, Travis CI GmbH
#
# All rights reserved - Do Not Redistribute
#

package Array(node['travis_build_environment']['packages']) do
  action :upgrade
end

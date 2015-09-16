#
# Cookbook Name:: rvm
# Recipe:: ruby_187

node.default[:rvm][:ruby][:implementation] = 'ruby'
node.default[:rvm][:ruby][:version] = '1.8.7'
include_recipe "rvm::install"

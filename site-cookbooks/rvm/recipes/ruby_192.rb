#
# Cookbook Name:: rvm
# Recipe:: ruby_192

node.default[:rvm][:ruby][:implementation] = 'ruby'
node.default[:rvm][:ruby][:version] = '1.9.2'
include_recipe "rvm::install"

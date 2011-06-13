#
# Cookbook Name:: rvm
# Recipe:: rbx_124

node.default[:rvm][:ruby][:implementation] = 'rbx'
node.default[:rvm][:ruby][:version] = '1.2.4'
include_recipe "rvm::install"

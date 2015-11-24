#
# Cookbook Name:: rvm
# Recipe:: ree

node.default[:rvm][:ruby][:implementation] = 'ree'
include_recipe "rvm::install"

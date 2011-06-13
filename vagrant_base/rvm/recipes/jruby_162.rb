#
# Cookbook Name:: rvm
# Recipe::jruby_162

node.default[:rvm][:ruby][:implementation] = 'jruby'
node.default[:rvm][:ruby][:version] = '1.6.2'
include_recipe "rvm::install"

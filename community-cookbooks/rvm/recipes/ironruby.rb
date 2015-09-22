#
# Cookbook Name:: rvm
# Recipe:: jruby

# Install deps as listed by recent revisions of RVM.
%w(curl mono-2.0-devel).each do |pkg|
  package pkg
end

node.default[:rvm][:ruby][:implementation] = 'ironruby'
include_recipe "rvm::install"

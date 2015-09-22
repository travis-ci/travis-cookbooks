#
# Cookbook Name:: rvm
# Recipe:: jruby

# Install deps as listed by recent revisions of RVM.
%w(curl g++ openjdk-6-jre-headless ant openjdk-6-jdk).each do |pkg|
  package pkg
end

node.default[:rvm][:ruby][:implementation] = 'jruby'
include_recipe "rvm::install"

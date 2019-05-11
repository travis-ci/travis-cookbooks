# frozen_string_literal: true

if node['kernel']['machine'] == 'ppc64le' && node['lsb']['codename'] == 'xenial'
  include_recipe 'travis_java::openjdk-r'
  package 'openjdk-7-jdk'
else
  package %w[
    icedtea-7-plugin
    openjdk-7-jdk
  ]
end

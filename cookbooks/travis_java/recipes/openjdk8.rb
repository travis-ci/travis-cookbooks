# frozen_string_literal: true

if node['lsb']['codename'] == 'xenial' && node['kernel']['machine'] == 'ppc64le'
  package %w[icedtea-8-plugin openjdk-8-jdk]
else
  include_recipe 'travis_java::openjdk-r'
  package 'openjdk-8-jdk'
end

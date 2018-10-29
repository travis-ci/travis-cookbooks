# frozen_string_literal: true

include_recipe 'travis_postgresql::pgdg'

unless node['travis_postgresql']['client_packages'].empty?
  package node['travis_postgresql']['client_packages']
end

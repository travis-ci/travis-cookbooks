# frozen_string_literal: true

include_recipe 'travis_groovy'

ark 'gradle' do
  url node['travis_build_environment']['gradle_url']
  version node['travis_build_environment']['gradle_version']
  checksum node['travis_build_environment']['gradle_checksum']
  has_binaries %w[bin/gradle]
  owner 'root'
  group 'root'
end

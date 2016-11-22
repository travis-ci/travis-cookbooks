ark 'yarn' do
  url node['travis_build_environment']['yarn_url']
  version node['travis_build_environment']['yarn_version']
  checksum node['travis_build_environment']['yarn_checksum']
  strip_components 1
  has_binaries node['travis_build_environment']['yarn_binaries']
end

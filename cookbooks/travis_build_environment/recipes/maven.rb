ark 'maven' do
  url node['travis_build_environment']['maven_url']
  version node['travis_build_environment']['maven_version']
  checksum node['travis_build_environment']['maven_checksum']
  strip_components 1
  has_binaries node['travis_build_environment']['maven_binaries']
end

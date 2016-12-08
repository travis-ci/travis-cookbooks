ark 'shellcheck' do
  url node['travis_build_environment']['shellcheck_url']
  version node['travis_build_environment']['shellcheck_version']
  checksum node['travis_build_environment']['shellcheck_checksum']
  strip_components 1
  has_binaries node['travis_build_environment']['shellcheck_binaries']
end

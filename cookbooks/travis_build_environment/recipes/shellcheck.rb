# frozen_string_literal: true

package 'shellcheck' do
  action %i[install upgrade]
  only_if { node['kernel']['machine'] == 'ppc64le' }
end

link '/usr/local/bin/shellcheck' do
  to '/usr/bin/shellcheck'
  only_if { node['kernel']['machine'] == 'ppc64le' }
end

ark 'shellcheck' do
  url node['travis_build_environment']['shellcheck_url']
  version node['travis_build_environment']['shellcheck_version']
  checksum node['travis_build_environment']['shellcheck_checksum']
  strip_components 1
  has_binaries node['travis_build_environment']['shellcheck_binaries']
  not_if { node['kernel']['machine'] == 'ppc64le' }
end

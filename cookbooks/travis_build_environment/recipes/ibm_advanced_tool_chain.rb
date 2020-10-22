# frozen_string_literal: true

apt_repository 'ibm_advanced_tool_chain' do
  uri node['travis_build_environment']['ibm_advanced_tool_chain_apt_deb_url']
  distribution node['lsb']['codename']
  components ["at#{node['travis_build_environment']['ibm_advanced_tool_chain_version']}"]
  arch 'amd64'
  key node['travis_build_environment']['ibm_advanced_tool_chain_apt_key_url']
  retries 2
  retry_delay 30
  only_if { node['kernel']['machine'] == 'amd64' }
end

apt_package 'install_ibm_advanced_toolchain' do
  case node['lsb']['codename']
  when 'xenial'
    package_name %w[advance-toolchain-cross-common
                    advance-toolchain-cross-ppc64le
                    advance-toolchain-cross-ppc64le-mcore-libs
                    advance-toolchain-cross-ppc64le-runtime-extras]
  when 'bionic', 'focal'
    package_name %w[advance-toolchain-cross-common
                    advance-toolchain-cross-ppc64le
                    advance-toolchain-cross-ppc64le-libnxz
                    advance-toolchain-cross-ppc64le-mcore-libs
                    advance-toolchain-cross-ppc64le-runtime-extras]
  end
  only_if { node['kernel']['machine'] == 'amd64' }
end

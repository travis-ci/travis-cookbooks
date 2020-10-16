# frozen_string_literal: true

ibm_advanced_tool_chain_bionic_and_focal_packges =
  %w[advance-toolchain-cross-common_14.0-0_amd64.deb
     advance-toolchain-cross-ppc64le-libnxz_14.0-0_amd64.deb
     advance-toolchain-cross-ppc64le-mcore-libs_14.0-0_amd64.deb
     advance-toolchain-cross-ppc64le-runtime-extras_14.0-0_amd64.deb
     advance-toolchain-cross-ppc64le_14.0-0_amd64.deb]

ibm_advanced_tool_chain_bionic_and_focal_packges.each do |deb_file|
  remote_file "#{Chef::Config.file_cache_path}/#{deb_file}" do
    source "#{node['travis_build_environment']['ibm_advanced_tool_chain_bionic_url']}/#{deb_file}"
    mode 0o755
    only_if { node['lsb']['codename'] == 'bionic' && node['kernel']['machine'] == 'amd64' }
  end

  dpkg_package deb_file do
    source "#{Chef::Config.file_cache_path}/#{deb_file}"
    action :install
    only_if { node['lsb']['codename'] == 'bionic' && node['kernel']['machine'] == 'amd64' }
  end

  remote_file "#{Chef::Config.file_cache_path}/#{deb_file}" do
    source "#{node['travis_build_environment']['ibm_advanced_tool_chain_focal_url']}/#{deb_file}"
    mode 0o755
    only_if { node['lsb']['codename'] == 'focal' && node['kernel']['machine'] == 'amd64' }
  end

  dpkg_package deb_file do
    source "#{Chef::Config.file_cache_path}/#{deb_file}"
    action :install
    only_if { node['lsb']['codename'] == 'focal' && node['kernel']['machine'] == 'amd64' }
  end
end

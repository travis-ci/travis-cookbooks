# frozen_string_literal: true

ibm_tool_chain_cross_common = 'advance-toolchain-cross-common_14.0-0_amd64.deb'
ibm_tool_chain_cross_libnxz = 'advance-toolchain-cross-ppc64le-libnxz_14.0-0_amd64.deb'
ibm_tool_chain_cross_mcore = 'advance-toolchain-cross-ppc64le-mcore-libs_14.0-0_amd64.deb'
ibm_tool_chain_cross_extras = 'advance-toolchain-cross-ppc64le-runtime-extras_14.0-0_amd64.deb'
ibm_tool_chain_cross = 'advance-toolchain-cross-ppc64le_14.0-0_amd64.deb'

# Bionic distribution

remote_file "#{Chef::Config.file_cache_path}/#{ibm_tool_chain_cross_common}" do
  source "#{node['travis_build_environment']['ibm_advanced_tool_chain_bionic_url']}/#{ibm_tool_chain_cross_common}"
  checksum node['travis_build_environment']['ibm_tool_chain_cross_common_bionic_checksum']
  mode 0o755
  only_if { node['lsb']['codename'] == 'bionic' && node['kernel']['machine'] == 'amd64' }
end

dpkg_package ibm_tool_chain_cross_common do
  source "#{Chef::Config.file_cache_path}/#{ibm_tool_chain_cross_common}"
  action :install
  only_if { node['lsb']['codename'] == 'bionic' && node['kernel']['machine'] == 'amd64' }
end

remote_file "#{Chef::Config.file_cache_path}/#{ibm_tool_chain_cross_libnxz}" do
  source "#{node['travis_build_environment']['ibm_advanced_tool_chain_bionic_url']}/#{ibm_tool_chain_cross_libnxz}"
  checksum node['travis_build_environment']['ibm_tool_chain_cross_libnxz_bionic_checksum']
  mode 0o755
  only_if { node['lsb']['codename'] == 'bionic' && node['kernel']['machine'] == 'amd64' }
end

dpkg_package ibm_tool_chain_cross_libnxz do
  source "#{Chef::Config.file_cache_path}/#{ibm_tool_chain_cross_libnxz}"
  action :install
  only_if { node['lsb']['codename'] == 'bionic' && node['kernel']['machine'] == 'amd64' }
end

remote_file "#{Chef::Config.file_cache_path}/#{ibm_tool_chain_cross_mcore}" do
  source "#{node['travis_build_environment']['ibm_advanced_tool_chain_bionic_url']}/#{ibm_tool_chain_cross_mcore}"
  checksum node['travis_build_environment']['ibm_tool_chain_cross_mcore_bionic_checksum']
  mode 0o755
  only_if { node['lsb']['codename'] == 'bionic' && node['kernel']['machine'] == 'amd64' }
end

dpkg_package ibm_tool_chain_cross_mcore do
  source "#{Chef::Config.file_cache_path}/#{ibm_tool_chain_cross_mcore}"
  action :install
  only_if { node['lsb']['codename'] == 'bionic' && node['kernel']['machine'] == 'amd64' }
end

remote_file "#{Chef::Config.file_cache_path}/#{ibm_tool_chain_cross_extras}" do
  source "#{node['travis_build_environment']['ibm_advanced_tool_chain_bionic_url']}/#{ibm_tool_chain_cross_extras}"
  checksum node['travis_build_environment']['ibm_tool_chain_cross_extras_bionic_checksum']
  mode 0o755
  only_if { node['lsb']['codename'] == 'bionic' && node['kernel']['machine'] == 'amd64' }
end

dpkg_package ibm_tool_chain_cross_extras do
  source "#{Chef::Config.file_cache_path}/#{ibm_tool_chain_cross_extras}"
  action :install
  only_if { node['lsb']['codename'] == 'bionic' && node['kernel']['machine'] == 'amd64' }
end

remote_file "#{Chef::Config.file_cache_path}/#{ibm_tool_chain_cross}" do
  source "#{node['travis_build_environment']['ibm_advanced_tool_chain_bionic_url']}/#{ibm_tool_chain_cross}"
  checksum node['travis_build_environment']['ibm_tool_chain_cross_bionic_checksum']
  mode 0o755
  only_if { node['lsb']['codename'] == 'bionic' && node['kernel']['machine'] == 'amd64' }
end

dpkg_package ibm_tool_chain_cross do
  source "#{Chef::Config.file_cache_path}/#{ibm_tool_chain_cross}"
  action :install
  only_if { node['lsb']['codename'] == 'bionic' && node['kernel']['machine'] == 'amd64' }
end

# Focal distribution

remote_file "#{Chef::Config.file_cache_path}/#{ibm_tool_chain_cross_common}" do
  source "#{node['travis_build_environment']['ibm_advanced_tool_chain_focal_url']}/#{ibm_tool_chain_cross_common}"
  checksum node['travis_build_environment']['ibm_tool_chain_cross_common_focal_checksum']
  mode 0o755
  only_if { node['lsb']['codename'] == 'focal' && node['kernel']['machine'] == 'amd64' }
end

dpkg_package ibm_tool_chain_cross_common do
  source "#{Chef::Config.file_cache_path}/#{ibm_tool_chain_cross_common}"
  action :install
  only_if { node['lsb']['codename'] == 'focal' && node['kernel']['machine'] == 'amd64' }
end

remote_file "#{Chef::Config.file_cache_path}/#{ibm_tool_chain_cross_libnxz}" do
  source "#{node['travis_build_environment']['ibm_advanced_tool_chain_focal_url']}/#{ibm_tool_chain_cross_libnxz}"
  checksum node['travis_build_environment']['ibm_tool_chain_cross_libnxz_focal_checksum']
  mode 0o755
  only_if { node['lsb']['codename'] == 'focal' && node['kernel']['machine'] == 'amd64' }
end

dpkg_package ibm_tool_chain_cross_libnxz do
  source "#{Chef::Config.file_cache_path}/#{ibm_tool_chain_cross_libnxz}"
  action :install
  only_if { node['lsb']['codename'] == 'focal' && node['kernel']['machine'] == 'amd64' }
end

remote_file "#{Chef::Config.file_cache_path}/#{ibm_tool_chain_cross_mcore}" do
  source "#{node['travis_build_environment']['ibm_advanced_tool_chain_focal_url']}/#{ibm_tool_chain_cross_mcore}"
  checksum node['travis_build_environment']['ibm_tool_chain_cross_mcore_focal_checksum']
  mode 0o755
  only_if { node['lsb']['codename'] == 'focal' && node['kernel']['machine'] == 'amd64' }
end

dpkg_package ibm_tool_chain_cross_mcore do
  source "#{Chef::Config.file_cache_path}/#{ibm_tool_chain_cross_mcore}"
  action :install
  only_if { node['lsb']['codename'] == 'focal' && node['kernel']['machine'] == 'amd64' }
end

remote_file "#{Chef::Config.file_cache_path}/#{ibm_tool_chain_cross_extras}" do
  source "#{node['travis_build_environment']['ibm_advanced_tool_chain_focal_url']}/#{ibm_tool_chain_cross_extras}"
  checksum node['travis_build_environment']['ibm_tool_chain_cross_extras_focal_checksum']
  mode 0o755
  only_if { node['lsb']['codename'] == 'focal' && node['kernel']['machine'] == 'amd64' }
end

dpkg_package ibm_tool_chain_cross_extras do
  source "#{Chef::Config.file_cache_path}/#{ibm_tool_chain_cross_extras}"
  action :install
  only_if { node['lsb']['codename'] == 'focal' && node['kernel']['machine'] == 'amd64' }
end

remote_file "#{Chef::Config.file_cache_path}/#{ibm_tool_chain_cross}" do
  source "#{node['travis_build_environment']['ibm_advanced_tool_chain_focal_url']}/#{ibm_tool_chain_cross}"
  checksum node['travis_build_environment']['ibm_tool_chain_cross_focal_checksum']
  mode 0o755
  only_if { node['lsb']['codename'] == 'focal' && node['kernel']['machine'] == 'amd64' }
end

dpkg_package ibm_tool_chain_cross do
  source "#{Chef::Config.file_cache_path}/#{ibm_tool_chain_cross}"
  action :install
  only_if { node['lsb']['codename'] == 'focal' && node['kernel']['machine'] == 'amd64' }
end

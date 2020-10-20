# frozen_string_literal: true

def installation_allowed?
  %w[bionic focal xenial].include?(node['lsb']['codename']) && node['kernel']['machine'] == 'amd64'
end

if installation_allowed?
  def deb_url
    base_url = node['travis_build_environment']['ibm_advanced_tool_chain_apt_deb_url']
    "#{base_url} #{node['lsb']['codename']} at#{node['travis_build_environment']['ibm_advanced_tool_chain_version']}"
  end

  execute "apt-key-add-ibm-advanced-tool-chain" do
    command "wget --auth-no-challenge -qO - #{node['travis_build_environment']['ibm_advanced_tool_chain_apt_key_url']} | apt-key add -"
    action :nothing
  end

  execute "apt-add-sources-list" do
    command "echo deb #{deb_url} > /etc/apt/sources.list.d/advanced_tool_chain.list"
    action :nothing
  end

  apt_update do
    action :update
  end

  apt_package 'install_ibm_advanced_toolchain' do
    package_name ["advance-toolchain-at#{node['travis_build_environment']['ibm_advanced_tool_chain_version']}-runtime",
                  "advance-toolchain-at#{node['travis_build_environment']['ibm_advanced_tool_chain_version']}-devel",
                  "advance-toolchain-at#{node['travis_build_environment']['ibm_advanced_tool_chain_version']}-perf",
                  "advance-toolchain-at#{node['travis_build_environment']['ibm_advanced_tool_chain_version']}-mcore-libs"]
  end
end

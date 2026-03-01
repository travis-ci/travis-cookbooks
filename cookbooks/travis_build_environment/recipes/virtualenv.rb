# frozen_string_literal: true

include_recipe 'travis_build_environment::pip'

case node['lsb']['codename']
when 'xenial', 'bionic', 'focal', 'jammy'
  execute "pip install virtualenv==#{node['travis_build_environment']['virtualenv']['version']}"
when 'noble'
  bash 'Install virtualenv using apt' do
    code <<-INSTALL_VIRTUALENV
      apt install -yq python3-virtualenv
      INSTALL_VIRTUALENV
  end
end

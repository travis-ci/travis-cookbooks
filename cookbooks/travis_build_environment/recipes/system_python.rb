# frozen_string_literal: true

virtualenv_root = File.join(node['travis_build_environment']['home'], 'virtualenv')

# Install Python2 and Python3
package %w[python-dev python3-dev]

# Create a directory to store our virtualenvs in
directory virtualenv_root do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode '0755'

  action :create
end

node['travis_build_environment']['system_python']['pythons'].each do |py|
  pyname = "python#{py}"
  venv_name = "#{pyname}_with_system_site_packages"
  venv_fullname = "#{virtualenv_root}/#{venv_name}"

  bash "create virtualenv at #{venv_fullname} from #{pyname}" do
    code "virtualenv --system-site-packages --python=/usr/bin/#{pyname} #{venv_fullname}"
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
  end

  packages = []

  node['travis_build_environment']['python_aliases'].fetch(py, []).concat(['default', py]).each do |name|
    packages.concat node['travis_build_environment']['pip']['packages'].fetch(name, [])
  end

  execute "install wheel in #{venv_name}" do
    command "#{venv_fullname}/bin/pip install --upgrade wheel"
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    environment(
      'HOME' => node['travis_build_environment']['home']
    )
  end

  execute "install packages in #{venv_name}" do
    command "#{venv_fullname}/bin/pip install --upgrade #{packages.join(' ')}"
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    environment(
      'HOME' => node['travis_build_environment']['home']
    )
  end
end

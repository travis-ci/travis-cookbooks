

include_recipe 'travis_python::pip'

cookbook_file '/etc/profile.d/virtualenv_settings.sh' do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o755
end

travis_python_pip 'virtualenv' do
  version '13.1.0'
  action :install
end

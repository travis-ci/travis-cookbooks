unless Array(node['phpenv']['prerequisite_recipes']).empty?
  Array(node['phpenv']['prerequisite_recipes']).each do |recipe_name|
    include_recipe recipe_name
  end
end

phpenv_clone = '/tmp/phpenv'
phpenv_path = "#{node['travis_build_environment']['home']}/.phpenv"

git phpenv_clone do
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  repository node['phpenv']['git']['repository']
  revision node['phpenv']['git']['revision']
  action :sync
end

bash 'install phpenv' do
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  cwd phpenv_clone
  code <<-EOF
    . bin/phpenv-install.sh
    cp extensions/rbenv-config-add #{phpenv_path}/libexec/
    cp extensions/rbenv-config-rm #{phpenv_path}/libexec/
  EOF
  environment(
    'PHPENV_ROOT' => phpenv_path
  )
  not_if "test -f #{phpenv_path}/bin/phpenv"
end

directory "#{phpenv_path}/versions" do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0755
  action :create
end

template '/etc/profile.d/phpenv.sh' do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  source 'phpenv.sh.erb'
  variables(phpenv_path: phpenv_path)
end

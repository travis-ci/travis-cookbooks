package 'perl'

bash 'install Perlbrew' do
  user node['travis_build_environment']['user']
  cwd node['travis_build_environment']['home']
  environment(
    'HOME' => node['travis_build_environment']['home']
  )
  code <<-SH
    curl -s https://raw.githubusercontent.com/gugod/App-perlbrew/master/perlbrew-install -o /tmp/perlbrew-installer
    chmod +x /tmp/perlbrew-installer
    bash /tmp/perlbrew-installer
  SH
  not_if "test -d #{node['travis_build_environment']['home']}/perl5/perlbrew"
end

cookbook_file '/etc/profile.d/perlbrew.sh' do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0755
end

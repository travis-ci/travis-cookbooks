unless Array(node['travis_perlbrew']['prerequisite_packages']).empty?
  package Array(node['travis_perlbrew']['prerequisite_packages'])
end

bash 'install perlbrew' do
  user node['travis_build_environment']['user']
  cwd node['travis_build_environment']['home']
  environment(
    'HOME' => node['travis_build_environment']['home']
  )

  code <<-EOSH.gsub(/^\s+>\s/, '')
    > curl -s https://raw.githubusercontent.com/gugod/App-perlbrew/master/perlbrew-install \\
    >   -o /tmp/perlbrew-installer
    > chmod +x /tmp/perlbrew-installer
    > bash /tmp/perlbrew-installer
  EOSH

  not_if do
    File.directory?("#{node['travis_build_environment']['home']}/perl5/perlbrew")
  end
end

cookbook_file '/etc/profile.d/perlbrew.sh' do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0755
end

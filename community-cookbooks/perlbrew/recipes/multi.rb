include_recipe 'perlbrew'

home = node['travis_build_environment']['home']
brew = "source #{home}/perl5/perlbrew/etc/bashrc && perlbrew"
env = { 'HOME' => home }
user = node['travis_build_environment']['user']

permissions = lambda do |bash|
  bash.user user
  bash.environment env
end

bash 'install cpanm' do
  permissions.call(self)
  code "#{brew} install-cpanm"
  not_if "ls #{home}/perl5/perlbrew/bin | grep cpanm"
end

node['perlbrew']['perls'].each do |pl|
  args = pl['arguments'].to_s
  args << ' --notest'

  bash "installing #{pl['version']} as #{pl['name']} with Perlbrew arguments: #{args}" do
    permissions.call(self)
    code "#{brew} install #{pl['version']} --as #{pl['name']} #{args}"
    not_if "ls #{home}/perl5/perlbrew/perls | grep #{pl['name']}"
  end

  if pl['alias']
    bash "creating alias #{pl['alias']} for #{pl['name']}" do
      permissions.call(self)
      code "#{brew} alias create #{pl['name']} #{pl['alias']}"
    end
  end

  node['perlbrew']['modules'].each do |mod|
    bash "preinstall #{mod} via cpanm" do
      permissions.call(self)
      code "#{brew} use #{pl['name']} && cpanm #{mod} --force --notest"
    end
  end

  bash "cleaning cpanm metadata for #{pl['version']}" do
    permissions.call(self)
    code 'rm -rf ~/.cpanm'
  end
end

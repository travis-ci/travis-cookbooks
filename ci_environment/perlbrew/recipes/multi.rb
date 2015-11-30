include_recipe "perlbrew"

home = node.travis_build_environment.home
brew = "source #{home}/perl5/perlbrew/etc/bashrc && perlbrew"
env  = { 'HOME' => home }
user = node.travis_build_environment.user

setup = lambda do |bash|
  bash.user user
  bash.environment env
end

bash "install cpanm" do
  setup.call(self)
  code "#{brew} install-cpanm"
  not_if "ls #{home}/perl5/perlbrew/bin | grep cpanm"
end

node.perlbrew.perls.each do |pl|
  dest_tarball = ::File.join(
    Chef::Config[:file_cache_path],
    "perl-#{pl['name']}.tar.bz2"
  )

  remote_file dest_tarball do
    source ::File.join(
      'https://s3.amazonaws.com/travis-perl-archives/binaries',
      node['platform'],
      node['platform_version'],
      node['kernel']['machine'],
      ::File.basename(dest_tarball)
    )
    owner 'root'
    group 'root'
    mode 0644
    ignore_failure true
  end

  bash "extract #{dest_tarball}" do
    code "tar -xjf #{dest_tarball} --directory /"
    only_if { ::File.exist?(dest_tarball) }
  end

  args = pl[:arguments].to_s
  args << " --notest"

  bash "installing #{pl[:version]} as #{pl[:name]} with Perlbrew arguments: #{args}" do
    setup.call(self)
    code   "#{brew} install #{pl[:version]} --as #{pl[:name]} #{args}"
    not_if "ls #{home}/perl5/perlbrew/perls | grep #{pl[:name]}"
  end

  if pl[:alias]
    bash "creating alias #{pl[:alias]} for #{pl[:name]}" do
      setup.call(self)
      code "#{brew} alias create #{pl[:name]} #{pl[:alias]}"
    end
  end

  node.perlbrew.modules.each do |mod|
    bash "preinstall #{mod} via cpanm" do
      setup.call(self)
      # remove the mirror for now as VMs are based in the US
      # --mirror 'http://cpan.mirrors.travis-ci.org'
      code   "#{brew} use #{pl[:name]} && cpanm #{mod} --force --notest"
      not_if { ::File.exist?(dest_tarball) }
    end
  end

  bash "cleaning cpanm metadata for #{pl[:version]}" do
    setup.call(self)
    code   "rm -rf ~/.cpanm"
  end
end

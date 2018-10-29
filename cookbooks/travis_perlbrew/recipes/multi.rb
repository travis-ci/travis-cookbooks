# frozen_string_literal: true

# Cookbook Name:: travis_perlbrew
# Recipe:: multi
# Copyright 2017 Travis CI GmbH
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

include_recipe 'travis_perlbrew'

home = node['travis_build_environment']['home']
perlbrew = "source #{home}/perl5/perlbrew/etc/bashrc && perlbrew"
env = { 'HOME' => home }
user = node['travis_build_environment']['user']

permissions = lambda do |bash|
  bash.user user
  bash.environment env
end

bash 'install cpanm' do
  permissions.call(self)
  code "#{perlbrew} install-cpanm"
  not_if { ::File.exist?("#{home}/perl5/perlbrew/bin/cpanm") }
end

node['travis_perlbrew']['perls'].each do |pl|
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
    mode 0o644
    ignore_failure true
  end

  bash "extract #{dest_tarball}" do
    code "tar -xjf #{dest_tarball} --directory /"
    only_if { ::File.exist?(dest_tarball) }
  end

  args = pl['arguments'].to_s
  args += ' --notest'

  bash "installing #{pl['version']} as #{pl['name']} " \
       "with Perlbrew arguments: #{args}" do
    permissions.call(self)
    code "#{perlbrew} install #{pl['version']} --as #{pl['name']} #{args}"
    not_if "ls #{home}/perl5/perlbrew/perls | grep #{pl['name']}"
  end

  bash "creating alias #{pl['alias']} for #{pl['name']}" do
    permissions.call(self)
    code "#{perlbrew} alias create #{pl['name']} #{pl['alias']}"
    only_if { pl['alias'] }
  end

  node['travis_perlbrew']['modules'].each do |mod|
    bash "preinstall #{mod} via cpanm for #{pl['version']}" do
      permissions.call(self)
      code "#{perlbrew} use #{pl['name']} && cpanm #{mod} --force --notest"
      not_if { ::File.exist?(dest_tarball) }
    end
  end

  bash "cleaning cpanm metadata for #{pl['version']}" do
    permissions.call(self)
    code 'rm -rf ~/.cpanm'
  end
end

#
# Cookbook Name:: sphinx
# Recipe:: all
# Copyright 2011-2013, Travis CI Development Team <contact@travis-ci.org>
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


package 'libmysql++-dev' do
  action :install
end

include_recipe "postgresql::client"

script 'download libstemmer once' do
  interpreter 'bash'
  code <<-SHELL
    mkdir -p /tmp/sphinx_install
    cd /tmp/sphinx_install
    wget http://snowball.tartarus.org/dist/libstemmer_c.tgz
  SHELL
end

node.sphinx.versions.each do |version, path|
  log("Installing Sphinx #{version} to #{path}") { level :debug }

  local_archive = ::File.join(
    Chef::Config[:file_cache_path]},
    "sphinx-#{version.delete('-release')}.tar.bz2"
  )

  remote_file local_archive do
    source ::File.join(
      'https://s3.amazonaws.com/travis-sphinx-archives/binaries',
      node['platform'],
      node['platform_version'],
      node['kernel']['machine'],
      ::File.basename(local_archive)
    )
    ignore_failure true
    not_if { ::File.exist?(local_archive) }
  end

  bash "Expand sphinx #{version.delete('-release')} archive" do
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    code "tar -xjf #{local_archive.inspect} --directory /"
    only_if { ::File.exist?(local_archive) }
  end

  remote_file "/tmp/sphinx_install/sphinx-#{version}.tar.gz" do
    source "http://www.sphinxsearch.com/files/sphinx-#{version}.tar.gz"
    owner 'root'
    group 'root'
    mode 0644
    not_if { ::File.exist?("#{path}/bin/searchd") }
  end

  execute "tar -xzf /tmp/sphinx_install/sphinx-#{version}.tar.gz -C /tmp/sphinx_install" do
    not_if { ::File.exist?("#{path}/bin/searchd") }
  end

  bash 'install sphinx with libstemmer' do
    code <<-SHELL
      cd /tmp/sphinx_install
      cp libstemmer_c.tgz sphinx-#{version}/libstemmer_c.tgz
      cd sphinx-#{version}
      tar -zxvf libstemmer_c.tgz
      sed -i -e 's/stem_ISO_8859_1_hungarian/stem_ISO_8859_2_hungarian/g' libstemmer_c/Makefile.in
      ./configure --with-mysql --with-pgsql --with-libstemmer --prefix=#{path}
      make && make install
    SHELL

    not_if { ::File.exist?("#{path}/bin/searchd") }
  end
end

%w(indexer indextool search searchd spelldump).each do |binary|
  link "/usr/local/bin/#{binary}" do
    to "/usr/local/sphinx-#{node.sphinx.linked}/bin/#{binary}"
  end
end

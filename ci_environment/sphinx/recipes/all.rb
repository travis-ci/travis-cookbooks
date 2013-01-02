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

  script 'install sphinx with libstemmer' do
    interpreter 'bash'
    code <<-SHELL
      cd /tmp/sphinx_install
      wget http://www.sphinxsearch.com/files/sphinx-#{version}.tar.gz
      tar zxvf sphinx-#{version}.tar.gz
      cp libstemmer_c.tgz sphinx-#{version}/libstemmer_c.tgz
      cd sphinx-#{version}
      tar zxvf libstemmer_c.tgz
      ./configure --with-mysql --with-pgsql --with-libstemmer --prefix=#{path}
      make && make install
    SHELL

    not_if "test -d #{path}"
  end
end

%w(indexer indextool search searchd spelldump).each do |binary|
  link "/usr/local/bin/#{binary}" do
    to "/usr/local/sphinx-#{node.sphinx.linked}/bin/#{binary}"
  end
end

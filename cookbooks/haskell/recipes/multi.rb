# Cookbook Name:: haskell
# Recipe:: multi
# Copyright 2012-2015, Travis CI Development Team <contact@travis-ci.org>
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

package %w(
  freeglut3
  freeglut3-dev
  libgmp3-dev
  libgmp3c2
)

link '/usr/lib/libgmp.so.3' do
  to '/usr/lib/libgmp.so.3.5.2'

  not_if 'test -L /usr/lib/libgmp.so.3'
end

ghc_dir = '/usr/local/ghc'

directory ghc_dir do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0755
  action :create
end

# download, unpack, build and install each ghc compiler and relater platform from sources
node['haskell']['multi']['ghcs'].each do |ghc_version|
  linux_name = ghc_version =~ /^7.8/ ? '-deb7' : ''
  ghc_tarball_name = "ghc-#{ghc_version}-#{node.ghc.arch}-unknown-linux#{linux_name}.tar.bz2"
  ghc_local_tarball = File.join(Chef::Config[:file_cache_path], ghc_tarball_name)
  ghc_version_dir = File.join(ghc_dir, ghc_version)

  directory ghc_version_dir do
    owner node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    mode 0755
    action :create
  end

  remote_file ghc_local_tarball  do
    source "http://www.haskell.org/ghc/dist/#{ghc_version}/#{ghc_tarball_name}"
    not_if "test -f #{ghc_local_tarball}"
  end

  bash 'build and install GHC' do
    user 'root'
    cwd '/tmp'
    code <<-EOS
      tar jfx #{ghc_local_tarball}
      cd ghc-#{ghc_version}
      ./configure --prefix=#{ghc_version_dir}
      make install
      cd ..
      rm -rf ghc-#{ghc_version}
      rm -v #{ghc_local_tarball}
    EOS
  end
end

# install cabal
apt_repository 'cabal-install-ppa' do
  uri 'http://ppa.launchpad.net/typeful/cabal-install/ubuntu'
  distribution node['lsb']['codename']
  components ['main']
  key '9DF71E85'
  keyserver 'keyserver.ubuntu.com'
  action :add
  only_if { node['lsb']['codename'] == 'precise' }
end

package %w(cabal-install alex happy)

cookbook_file '/etc/profile.d/cabal.sh' do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0755
end

template '/usr/local/bin/ghc_find' do
  source 'ghc_find.erb'
  mode 0755
  owner 'root'
  group node['travis_build_environment']['group']
  variables(
    versions: node['haskell']['multi']['ghcs'].sort.reverse,
    default: node['haskell']['multi']['default']
  )
end

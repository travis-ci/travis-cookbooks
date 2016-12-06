# Cookbook Name:: travis_python
# Recipe:: pyenv
#
# Copyright 2011-2015, Travis CI Development Team <contact@travis-ci.org>
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

include_recipe 'travis_python::virtualenv'

virtualenv_root = "#{node['travis_build_environment']['home']}/virtualenv"
ug_perms = %W(
  #{node['travis_build_environment']['user']}
  #{node['travis_build_environment']['group']}
).join(':')

package %w(
  build-essential
  curl
  libbz2-dev
  liblzma-dev
  libncurses-dev
  libreadline-dev
  libsqlite3-dev
  libssl-dev
  llvm
  make
  tk-dev
  wget
  zlib1g-dev
)

git '/opt/pyenv' do
  repository 'https://github.com/yyuu/pyenv.git'
  revision node['travis_python']['pyenv']['revision']
  action :sync
end

execute '/opt/pyenv/plugins/python-build/install.sh'

directory '/opt/python' do
  owner 'root'
  group 'root'
  mode 0755
end

%W(
  #{node['travis_build_environment']['home']}/.pyenv
  #{node['travis_build_environment']['home']}/.pyenv/versions
).each do |dirname|
  directory dirname do
    owner node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    mode 0755
  end
end

build_environment = {
  'PYTHON_CONFIGURE_OPTS' => %w(
    --enable-unicode=ucs4
    --with-wide-unicode
    --enable-shared
    --enable-ipv6
    --enable-loadable-sqlite-extensions
    --with-computed-gotos
  ).join(' '),
  'PYTHON_CFLAGS' => %w(
    -g
    -fstack-protector
    --param=ssp-buffer-size=4
    -Wformat
    -Werror=format-security
  ).join(' ')
}

bindirs = %w(/opt/pyenv/bin)

node['travis_python']['pyenv']['pythons'].each do |py|
  pyname = py
  downloaded_tarball = ::File.join(
    Chef::Config[:file_cache_path], "#{py}.tar.bz2"
  )

  if /^\d+\.\d+(?:\.\d+)?(?:-dev)?$/ =~ py
    pyname = "python#{py}"
    downloaded_tarball = ::File.join(
      Chef::Config[:file_cache_path], "python-#{py}.tar.bz2"
    )
  end

  bindirs << "/opt/python/#{py}/bin"
  virtualenv_name = "#{virtualenv_root}/#{pyname}"
  downloaded_tarball = "#{Chef::Config[:file_cache_path]}/python-#{py}.tar.bz2"

  remote_file downloaded_tarball do
    source ::File.join(
      'https://s3.amazonaws.com/travis-python-archives/binaries',
      node['platform'],
      node['platform_version'],
      node['kernel']['machine'],
      ::File.basename(downloaded_tarball)
    )
    owner 'root'
    group 'root'
    mode 0644
    ignore_failure true
  end

  bash "extract #{downloaded_tarball}" do
    code "tar -xjf #{downloaded_tarball} --directory /"
    creates "/opt/python/#{py}"
    environment build_environment
    only_if { ::File.exist?(downloaded_tarball) }
  end

  bash "build #{py}" do
    code "python-build #{py} /opt/python/#{py}"
    creates "/opt/python/#{py}"
    environment build_environment
    not_if { ::File.exist?("/opt/python/#{py}") }
  end

  link "/opt/python/#{py}/bin/#{pyname}" do
    to "/opt/python/#{py}/bin/python"
    owner node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
  end

  link "#{node['travis_build_environment']['home']}/.pyenv/versions/#{py}" do
    to "/opt/python/#{py}"
    owner node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
  end

  bash "fix pyenv #{pyname} perms" do
    code "chown -R #{ug_perms} /opt/python/#{py}"
  end

  base_pyexe = "/opt/python/#{py}/bin/python"

  bash "install pyenv base #{pyname} packages" do
    code "#{base_pyexe} -m pip.__main__ install -U setuptools wheel virtualenv"
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    environment('HOME' => node['travis_build_environment']['home'])
  end

  python_virtualenv virtualenv_name do
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    python "/opt/python/#{py}/bin/python"
    action :create
  end

  node['travis_python']['pyenv']['aliases'].fetch(py, []).each do |pyalias|
    if /^\d+\.\d+(?:\.\d+)?(?:-dev)?$/ =~ py
      pyaliasname = "python#{pyalias}"
    else
      pyaliasname = pyalias
    end

    link "#{virtualenv_root}/#{pyaliasname}" do
      to venv_fullname
      owner node['travis_build_environment']['user']
      group node['travis_build_environment']['group']
    end
  end

  if py =~ /^pypy3/
    link "/opt/python/#{py}/bin/pypy3" do
      to "/opt/python/#{py}/bin/#{py}"
      not_if "test -f /opt/python/#{py}/bin/pypy3"
    end
  end

  packages = []

  node['travis_python']['pyenv']['aliases'].fetch(py, []).concat(['default', py]).each do |name|
    packages.concat(node['travis_python']['pip']['packages'].fetch(name, []))
  end

  venv = resources("python_virtualenv[#{virtualenv_name}]")
  pyexe = venv.python_binary

  bash "fix #{pyname} virtualenv perms" do
    code "chown -R #{ug_perms} #{venv.path}"
  end

  bash "install pyenv #{pyname} packages" do
    code "#{pyexe} -m pip.__main__ install #{Shellwords.join(packages)}"
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    environment('HOME' => node['travis_build_environment']['home'])
  end

  # This fails with perms errors on `/root/.cache`, but seems we can't set
  # environment('HOME' => ...) or equiv easily.
  #
  # python_package packages do
  #   virtualenv virtualenv_name
  #   user node['travis_build_environment']['user']
  #   group node['travis_build_environment']['group']
  # end
end

file "#{node['travis_build_environment']['home']}/.pyenv/version" do
  content "#{node['travis_python']['pyenv']['pythons'].first}\n"
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0644
end

template '/etc/profile.d/pyenv.sh' do
  source 'pyenv.sh.erb'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0644
  variables(
    bindirs: bindirs,
    build_environment: build_environment
  )
  backup false
end

bash 'pyenv rehash' do
  code 'source /etc/profile.d/pyenv.sh && pyenv rehash'
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  environment('HOME' => node['travis_build_environment']['home'])
end

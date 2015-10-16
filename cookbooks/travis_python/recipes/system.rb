# Cookbook Name:: travis_python
# Recipe:: system
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

virtualenv_root = File.join(node['travis_build_environment']['home'], 'virtualenv')

# Install Python2 and Python3
package %w(python-dev python3-dev)

# Create a directory to store our virtualenvs in
directory virtualenv_root do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode '0755'

  action :create
end

node['travis_python']['system']['pythons'].each do |py|
  pyname = "python#{py}"

  python_virtualenv "#{pyname}_with_system_site_packages" do
    owner node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    interpreter "/usr/bin/#{pyname}"
    path "#{virtualenv_root}/#{pyname}_with_system_site_packages"
    system_site_packages true

    action :create
  end

  # Build a list of packages up so that we can install them
  packages = []
  node['travis_python']['pyenv']['aliases'].fetch(py, []).concat(['default', py]).each do |name|
    packages.concat node['travis_python']['pip']['packages'].fetch(name, [])
  end

  # Install all of the pre-installed packages we want
  execute "install packages #{pyname}_with_system_site_packages" do
    command "#{virtualenv_root}/#{pyname}_with_system_site_packages/bin/pip install --upgrade #{packages.join(' ')}"
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    environment(
      'HOME' => node['travis_build_environment']['home']
    )
  end
end

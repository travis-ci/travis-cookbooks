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

include_recipe 'travis_python::virtualenv'

virtualenv_root = "#{node['travis_build_environment']['home']}/virtualenv"

node['travis_python']['system']['pythons'].each do |python_version|
  python_runtime python_version do
    options :system, dev_package: true
  end
end

node['travis_python']['system']['pythons'].each do |py|
  pyname = "python#{py}"
  venv_name = "#{pyname}_with_system_site_packages"
  venv_fullname = "#{virtualenv_root}/#{venv_name}"

  virtualenv_name = "#{virtualenv_root}/#{pyname}_with_system_site_packages"

  python_virtualenv virtualenv_name do
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    python "/usr/bin/#{pyname}"
    system_site_packages true
  end

  packages = []

  node['travis_python']['pyenv']['aliases'].fetch(py, []).concat(['default', py]).each do |name|
    packages.concat node['travis_python']['pip']['packages'].fetch(name, [])
  end

  pyexe = resources("python_virtualenv[#{virtualenv_name}]").python_binary

  bash "install system #{pyname} packages" do
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
  #   action :nothing
  # end
end

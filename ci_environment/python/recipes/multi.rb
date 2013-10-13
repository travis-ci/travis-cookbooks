#
# Cookbook Name:: python::dead_snakes_ppa
# Recipe:: default
# Copyright 2011, Michael S. Klishin & Travis CI Development Team
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

# python2.6 fails to install because some dependency in base VM images
# creates this directory and it confuses apt. MK.
directory "/usr/lib/python2.6/site-packages" do
  recursive true
  action :delete
  ignore_failure true
end

include_recipe "pypy::tarball" if node.python.multi.pythons.include?("pypy")


case node['platform']
when "ubuntu"
  apt_repository "fkrull_deadsnakes" do
    uri          "http://ppa.launchpad.net/fkrull/deadsnakes/ubuntu"
    distribution node['lsb']['codename']
    components   ['main']

    key          "DB82666C"
    keyserver    "keyserver.ubuntu.com"

    action :add
  end
end

case node['platform']
when "ubuntu"
  apt_repository "travis_ci_python33" do
    uri          "http://ppa.launchpad.net/travis-ci/python3.3/ubuntu"
    distribution node['lsb']['codename']
    components   ['main']

    key          "75E9BCC5"
    keyserver    "keyserver.ubuntu.com"

    action :add
  end
end


python_pkgs = value_for_platform(["debian","ubuntu"] => {
                                   "default" => node.python.multi.pythons
                                 })

# not a good practice but sufficient for travis-ci.org needs, so lets keep it
# hardcoded. MK.
installation_root = File.join(node.travis_build_environment.home, "virtualenv")

directory(installation_root) do
  owner node.travis_build_environment.user
  group node.travis_build_environment.group
  mode  "0755"

  action :create
end
# virtualenv includes pip. MK.
include_recipe "python::virtualenv"

node.python.multi.pythons.each do |py|
  # pypy is provisioned via tarball. MK.
  unless py == "pypy"
    log "Installing #{py}"
    package py do
      action :install
    end

    package "#{py}-dev" do
      action :install
    end
  end

  packages = if ["python3.3", "3.3", "python3.2", "3.2", "pypy"].include?(py.to_s.downcase)
               # some versions fail to install NumPy. MK.
               node.python.pip.packages.reject { |p| p =~ /numpy/ }
             else
               node.python.pip.packages
             end



  log "Creating a new virtualenv for #{py} w/o --system-site-packages"
  python_virtualenv "python_#{py}" do
    owner       node.travis_build_environment.user
    group       node.travis_build_environment.group
    interpreter py
    path        "#{installation_root}/#{py}"

    action :create
  end


  script "preinstall pip packages for virtualenv set 1 (#{py})" do
    interpreter "bash"
    user        node.travis_build_environment.user
    group       node.travis_build_environment.group

    cwd node.travis_build_environment.home
    code <<-EOH
    #{installation_root}/#{py}/bin/pip install --quiet #{packages.join(' ')} --use-mirrors
    EOH

    environment({ "VIRTUAL_ENV_DISABLE_PROMPT" => "true" })
  end



  log "Creating a new virtualenv for #{py} with --system-site-packages"
  python_virtualenv "python_#{py}_with_system_site_packages" do
    owner       node.travis_build_environment.user
    group       node.travis_build_environment.group
    interpreter py
    system_site_packages true
    path        "#{installation_root}/#{py}_with_system_site_packages"

    action :create
  end


  script "preinstall pip packages for virtualenv set 2 (#{py})" do
    interpreter "bash"
    user        node.travis_build_environment.user
    group       node.travis_build_environment.group

    cwd node.travis_build_environment.home
    code <<-EOH
    #{installation_root}/#{py}_with_system_site_packages/bin/pip install --quiet #{packages.join(' ')} --use-mirrors
    EOH

    environment({ "VIRTUAL_ENV_DISABLE_PROMPT" => "true" })
  end
end

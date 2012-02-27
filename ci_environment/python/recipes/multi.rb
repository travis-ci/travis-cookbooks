#
# Cookbook Name:: python::dead_snakes_ppa
# Recipe:: default
# Copyright 2011, Michael S. Klishin & Travis CI development team
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


python_pkgs = value_for_platform(
                                 ["debian","ubuntu"] => {
                                   "default" => node.python.multi.pythons
                                 }
                                 )

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
  log "Installing #{py}"
  package py do
    action :install
  end
  package "#{py}-dev" do
    action :install
  end

  script "preinstall pip packages" do
    interpreter "bash"
    user        node.travis_build_environment.user
    group       node.travis_build_environment.group

    cwd node.travis_build_environment.home
    code <<-EOH
    #{installation_root}/#{py}/bin/pip install --quiet #{node.python.pip.packages.join(' ')} --use-mirrors
    sleep 10 # prevent # of concurrent slow connections to go above VirtualBox NIC NAT limit. See Vagrant issue #516. MK.
    EOH

    environment({ "VIRTUAL_ENV_DISABLE_PROMPT" => "true" })

    action :nothing
  end


  log "Creating a new virtualenv for #{py}"
  python_virtualenv node.travis_build_environment.home do
    owner       node.travis_build_environment.user
    group       node.travis_build_environment.group
    interpreter py
    path        "#{installation_root}/#{py}"

    action :create
    # commented out until we find a workaround for Vagrant issue #516
    notifies :run, resources(:script => "preinstall pip packages")
  end
end

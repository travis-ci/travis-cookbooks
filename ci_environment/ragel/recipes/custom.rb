#
# Cookbook Name:: ragel
# Recipe:: custom
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

require "tmpdir"
require "rbconfig"

tmp = Dir.tmpdir
case node[:platform]
when "debian", "ubuntu"
  pkg = if RbConfig::CONFIG['arch'] =~ /64/
              "ragel_6.7-1_amd64.deb"
            else
              "ragel_6.7-1_i386.deb"
            end

  path = File.join(tmp, pkg)

  remote_file(path) do
    source "http://files.travis-ci.org/packages/deb/ragel/#{pkg}"
    owner node.travis_build_environment.user
    group node.travis_build_environment.group
  end

  file(path) do
    action :nothing
  end

  package(pkg) do
    action   :install
    source   path
    provider Chef::Provider::Package::Dpkg

    notifies :delete, resources(:file => path)
    not_if "which ragel"
  end
end

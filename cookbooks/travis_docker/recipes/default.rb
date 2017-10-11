# Cookbook Name:: travis_docker
# Recipe:: default
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

include_recipe 'travis_docker::package'

group 'docker' do
  members node['travis_docker']['users']
  action %i[create manage]
end

cookbook_file '/etc/default/docker' do
  source 'etc/default/docker'
  owner 'root'
  group 'root'
  mode 0o640
end

directory '/etc/default/grub.d' do
  owner 'root'
  group 'root'
  mode 0o755
end

cookbook_file '/etc/default/grub.d/99-travis-settings.cfg' do
  source 'etc/default/grub.d/99-travis-settings.cfg'
  owner 'root'
  group 'root'
  mode 0o640
end

execute 'update-grub' do
  only_if { node['travis_docker']['update_grub'] }
end

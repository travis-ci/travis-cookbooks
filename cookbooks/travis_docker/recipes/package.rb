# frozen_string_literal: true

# Cookbook:: travis_docker
# Recipe:: package
# Copyright:: 2017 Travis CI GmbH
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

arch = node['kernel']['machine'] =~ /x86_64/ ? 'amd64' : 'ppc64el'
apt_repository 'docker' do
  uri 'https://download.docker.com/linux/ubuntu'
  arch arch
  components %w(stable edge)
  key 'https://download.docker.com/linux/ubuntu/gpg'
  retries 2
  retry_delay 30
  action :add
end

case node['lsb']['codename']
when 'xenial'
  pkgs = %w(linux-generic-lts-xenial linux-image-generic-lts-xenial)
when 'bionic'
  pkgs = %w(linux-generic linux-image-generic)
else
  pkgs = %w(linux-generic linux-image-generic)
end

package pkgs do
  action %i(install upgrade)
end

case node['lsb']['codename']
when 'trusty', 'xenial'
  package 'docker-ce' do
    version node['travis_docker']['version']
  end
else
  package 'docker.io'
end

group 'adding user to docker group' do
  group_name 'docker'
  members node['travis_docker']['users']
  action %i(create manage)
end

apt_repository 'docker' do
  action :remove
  not_if { node['travis_build_environment']['docker']['keep_repo'] }
end

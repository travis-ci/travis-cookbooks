# Cookbook Name:: travis_docker
# Recipe:: package
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

apt_repository 'docker' do
  uri 'https://download.docker.com/linux/ubuntu'
  arch 'amd64'
  distribution node['lsb']['codename']
  components %w[stable edge]
  key 'https://download.docker.com/linux/ubuntu/gpg'
  retries 2
  retry_delay 30
  action :add
  not_if { node['kernel']['machine'] == 'ppc64le' }
end

apt_repository 'docker' do
  uri node['travis_docker']['ppc64le']['apt']['url']
  trusted true
  components %w[main]
  only_if { node['kernel']['machine'] == 'ppc64le' }
end

package %w[linux-generic-lts-xenial linux-image-generic-lts-xenial] do
  action %i[install upgrade]
end

package 'docker-ce' do
  version node['travis_docker']['version']
end

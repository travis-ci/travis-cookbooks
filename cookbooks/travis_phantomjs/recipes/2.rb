# frozen_string_literal: true

# Cookbook Name:: travis_phantomjs
# Recipe:: 2
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

package %w[
  libicu-dev
  libjpeg-dev
  libpng-dev
]

ark 'phantomjs' do
  url 'https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2'
  version '2.1.1'
  checksum '86dd9a4bf4aee45f1a84c9f61cf1947c1d6dce9b9e8d2a907105da7852460d2f'
  has_binaries %w[bin/phantomjs]
  owner 'root'
  not_if { node['kernel']['machine'] == 'ppc64le' }
end

ark 'phantomjs' do
  url 'https://github.com/ibmsoe/phantomjs/releases/download/2.1.1/phantomjs-2.1.1-linux-ppc64.tar.bz2'
  version '2.1.1'
  has_binaries %w[phantomjs]
  owner 'root'
  only_if { node['kernel']['machine'] == 'ppc64le' }
end

cookbook_file '/etc/profile.d/phantomjs.sh' do
  source 'etc/profile.d/phantomjs.sh'
  owner 'root'
  group 'root'
  mode 0o644
  only_if { node['kernel']['machine'] == 'ppc64le' }
end

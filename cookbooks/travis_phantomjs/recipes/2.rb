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

package %w(
  libicu-dev
  libjpeg-dev
  libpng-dev
)

ark 'phantomjs' do
  url ::File.join(
    'https://s3.amazonaws.com/travis-phantomjs',
    node['platform'],
    node['platform_version'],
    node['kernel']['machine'],
    'phantomjs-2.0.0.tar.bz2'
  )
  version '2.0.0'
  checksum '785913935b14dfadf759e6f54fc6858eadab3c15b87f88a720b0942058b5b573'
  has_binaries %w(phantomjs)
  owner 'root'
end

# frozen_string_literal: true

# Cookbook:: travis_build_environment
# Recipe:: clang_tarball
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

case node['lsb']['codename']
when 'noble'
  execute 'clang_llvm_install' do
    command 'sudo apt update -yqq && sudo apt install clang llvm -y'
  end
when 'xenial', 'bionic', 'focal', 'jammy'
  ark 'clang' do
    url node['travis_build_environment']['clang']['download_url']
    checksum node['travis_build_environment']['clang']['checksum']
    version node['travis_build_environment']['clang']['version']
    extension node['travis_build_environment']['clang']['extension']
    retries 2
    retry_delay 30
    append_env_path true
  end
end

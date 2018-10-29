# frozen_string_literal: true

# Cookbook Name:: travis_build_environment
# Recipe:: rabbitmq
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

directory '/etc/rabbitmq' do
  owner 'root'
  group 'root'
  mode 0o755
end

file '/etc/rabbitmq/rabbitmq-env.conf' do
  content "NODENAME=rabbit@localhost\n"
  owner 'root'
  group 'root'
  mode 0o644
end

packagecloud_repo 'rabbitmq/rabbitmq-server' do
  type 'deb'
end

package 'rabbitmq-server' do
  # Pin to the latest 3.6 release since 3.7 requires Erlang/OTP 19.3+,
  # which is newer than the stock Ubuntu package:
  # https://github.com/travis-ci/travis-cookbooks/issues/953
  # TODO: Install newer OTP from an upstream APT repo and unpin here.
  version '3.6.14-1'
end

execute 'rabbitmq-plugins enable rabbitmq_management'

service 'rabbitmq-server' do
  action %i[stop disable]
end

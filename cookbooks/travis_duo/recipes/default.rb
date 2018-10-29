# frozen_string_literal: true

# Cookbook Name:: travis_duo
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

package %w[libssl-dev libpam-dev]

apt_repository 'duosecurity' do
  uri 'http://pkg.duosecurity.com/Ubuntu'
  distribution node['lsb']['codename']
  components %w[main]
  key 'https://duo.com/APT-GPG-KEY-DUO'
  retries 2
  retry_delay 30
end

package 'duo-unix'

%w[
  /etc/duo/login_duo.conf
  /etc/duo/pam_duo.conf
].each do |conf_path|
  template conf_path do
    source 'duo.conf.erb'
    owner node['travis_duo']['user']
    group node['travis_duo']['group'] || node['travis_duo']['user']
    mode 0o600
  end
end

directory '/lib/security' do
  owner 'root'
  group 'root'
  mode 0o755
end

link '/lib/security/pam_duo.so' do
  to '/lib64/security/pam_duo.so'
  only_if do
    ::File.exist?('/lib64/security/pam_duo.so') &&
      !::File.exist?('/lib/security/pam_duo.so')
  end
end

template '/etc/pam.d/sshd' do
  source 'pam.d-sshd.conf.erb'
  owner node['travis_duo']['user']
  group node['travis_duo']['group'] || node['travis_duo']['user']
  mode 0o600
end

template '/etc/pam.d/common-auth' do
  source 'pam.d-common-auth.conf.erb'
  owner node['travis_duo']['user']
  group node['travis_duo']['group'] || node['travis_duo']['user']
  mode 0o600
end

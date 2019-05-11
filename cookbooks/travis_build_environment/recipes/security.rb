# frozen_string_literal: true

# Cookbook Name:: travis_build_environment
# Recipe:: security
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

%w[user system].each do |target|
  dir = "/etc/systemd/#{target}.conf.d"

  directory dir do
    owner 'root'
    group 'root'
    mode 0o755
  end

  template "#{dir}/limits.conf" do
    source 'etc-systemd-conf-d-limits.conf.erb'
    owner 'root'
    group 'root'
    mode 0o644
  end
end

template '/etc/security/limits.conf' do
  source 'etc/security/limits.conf.erb'
  owner 'root'
  group 'root'
  mode 0o644
end

execute 'systemctl daemon-reexec'

cookbook_file '/etc/sudoers.d/env_keep' do
  source 'etc/sudoers/env_keep'
  owner 'root'
  group 'root'
  mode 0o440
end

ruby_block 'require pam_limits.so for su' do
  block do
    fe = Chef::Util::FileEdit.new('/etc/pam.d/su')
    fe.search_file_replace_line(
      /^# session    required   pam_limits.so/,
      'session    required   pam_limits.so'
    )
    fe.write_file
  end
end

execute 'update-rc.d disable-apparmor defaults' do
  action :nothing
  only_if { node['travis_build_environment']['disable_apparmor'] }
end

template '/etc/init.d/disable-apparmor' do
  source 'etc/init.d/disable-apparmor.sh.erb'
  owner 'root'
  group 'root'
  mode 0o750
  notifies :run, 'execute[update-rc.d disable-apparmor defaults]'
  only_if { node['travis_build_environment']['disable_apparmor'] }
end

execute '/usr/sbin/update-ca-certificates -f'

#
# Cookbook Name:: travis_build_environment
# Recipe:: default
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

include_recipe 'timezone'
include_recipe 'sysctl'
include_recipe 'openssh'
include_recipe 'unarchivers'
include_recipe 'travis_build_environment::root'
include_recipe 'travis_build_environment::ci_user'

cookbook_file '/etc/default/locale' do
  source 'etc/default/locale.sh'
  owner 'root'
  group 'root'
  mode 0644
end

execute 'locale-gen en_US.UTF-8'
execute 'dpkg-reconfigure locales'

bits = (node.kernel.machine =~ /x86_64/ ? 64 : 32)
hostname = case [node[:platform], node[:platform_version]]
           when ["ubuntu", "11.04"] then
             "natty#{bits}"
           when ["ubuntu", "11.10"] then
             "oneiric#{bits}"
           when ["ubuntu", "12.04"] then
             "precise#{bits}"
           when ["ubuntu", "14.04"] then
             "trusty#{bits}"
           end

template '/etc/hosts' do
  source 'etc/hosts.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables(hostname: hostname)
  only_if { node['travis_build_environment']['update_hosts'] }
end

template '/etc/hostname' do
  source 'etc/hostname.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables(hostname: hostname)
  only_if { node['travis_build_environment']['update_hosts'] }
end

execute "hostname #{hostname}" do

template '/etc/security/limits.conf' do
  source 'etc/security/limits.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
end

template '/etc/apt/apt.conf.d/60assumeyes' do
  source 'etc/apt/assumeyes.erb'
  owner 'root'
  group 'root'
  mode 0644
end

template '/etc/apt/apt.conf.d/37timeouts' do
  source 'etc/apt/timeouts.erb'
  owner 'root'
  group 'root'
  mode 0644
end

cookbook_file '/etc/sudoers.d/env_keep' do
  source 'etc/sudoers/env_keep'
  owner 'root'
  group 'root'
  mode 0440
end

include_recipe 'iptables'

template '/etc/environment' do
  source 'etc/environment.sh.erb'
  owner 'root'
  group 'root'
  mode 0644
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

package %w(apparmor apparmor-utils) do
  action :remove
  ignore_failure true
end

execute 'rm /etc/update-motd.d/*' do
  ignore_failure true
end

execute '/usr/sbin/update-ca-certificates -f'

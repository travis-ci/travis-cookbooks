# frozen_string_literal: true

# Cookbook Name:: travis_build_environment
# Recipe:: hostname
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

include_recipe 'travis_build_environment::cloud_init'

bits = case node['kernel']['machine']
       when /x86_64/
         64
       when 'ppc64le'
         'ppc64le'
       else
         32
       end

hostname = case [node['platform'], node['platform_version']]
           when ['ubuntu', '11.04'] then
             "natty#{bits}"
           when ['ubuntu', '11.10'] then
             "oneiric#{bits}"
           when ['ubuntu', '12.04'] then
             "precise#{bits}"
           when ['ubuntu', '14.04'] then
             "trusty#{bits}"
           when ['ubuntu', '16.04'] then
             "xenial#{bits}"
           end

template '/etc/hosts' do
  source 'etc/hosts.erb'
  owner 'root'
  group 'root'
  mode 0o644
  variables(hostname: hostname)
  only_if { node['travis_build_environment']['update_hosts'] }
  not_if { File.exist?('/.dockerenv') }
end

%w[
  /etc/cloud
  /etc/cloud/templates
].each do |dirname|
  directory dirname do
    mode 0o755
  end
end

%w[
  /etc/cloud/templates/hosts.debian.tmpl
  /etc/cloud/templates/hosts.tmpl
  /etc/cloud/templates/hosts.ubuntu.tmpl
].each do |filename|
  template filename do
    source 'etc-cloud-templates-hosts.tmpl.erb'
    owner 'root'
    group 'root'
    mode 0o644
    variables(hostname: hostname)
  end
end

template '/etc/hostname' do
  source 'etc/hostname.erb'
  owner 'root'
  group 'root'
  mode 0o644
  variables(hostname: hostname)
  only_if { node['travis_build_environment']['update_hosts'] }
  not_if { File.exist?('/.dockerenv') }
end

execute "hostname #{hostname}" do
  only_if { node['travis_build_environment']['update_hostname'] }
  not_if { File.exist?('/.dockerenv') }
end

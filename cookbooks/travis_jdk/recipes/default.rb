# frozen_string_literal: true

# Cookbook:: travis_jdk
# Recipe:: default
#
# The MIT License (MIT)
#
# Copyright:: 2025, Travis CI GmbH
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

versions = [
  node['travis_jdk']['default'],
  node['travis_jdk']['versions'],
].flatten.uniq

cookbook_file '/usr/local/bin/install-jdk.sh' do
  source 'install-jdk.sh'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  sensitive true
end

apt_update do
  action :update
end

apt_package 'default_java' do
  package_name %w(default-jre)
end

versions.each do |jdk|
  next if jdk.nil?

  target = ::File.join(node['travis_jdk']['destination_path'], jdk)

  version = jdk[/\d+/]

  bash "Install #{jdk}" do
    code <<-EOH
      #{node['travis_jdk']['install-jdk.sh_path']} --feature #{version} --target #{target}
    EOH
    not_if { ::File.exist?("#{target}/bin/java") }
  end
end

include_recipe 'travis_build_environment::bash_profile_d'

template ::File.join(
  node['travis_build_environment']['home'],
  '.bash_profile.d/travis_jdk.bash'
) do
  source 'travis_jdk.bash.erb'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode '644'
  variables(
    jdk: node['travis_jdk']['default'],
    path: node['travis_jdk']['destination_path'],
    docker: node['virtualization']['system'] == 'docker'
  )
end

# frozen_string_literal: true

# Cookbook Name:: travis_perlbrew
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

unless Array(node['travis_perlbrew']['prerequisite_packages']).empty?
  package Array(node['travis_perlbrew']['prerequisite_packages'])
end

bash 'install perlbrew' do
  user node['travis_build_environment']['user']
  cwd node['travis_build_environment']['home']
  environment(
    'HOME' => node['travis_build_environment']['home']
  )

  code <<-EOSH.gsub(/^\s+>\s/, '')
    > curl -s https://raw.githubusercontent.com/gugod/App-perlbrew/master/perlbrew-install \\
    >   -o /tmp/perlbrew-installer
    > chmod +x /tmp/perlbrew-installer
    > bash /tmp/perlbrew-installer
  EOSH

  not_if do
    File.directory?("#{node['travis_build_environment']['home']}/perl5/perlbrew")
  end
end

include_recipe 'travis_build_environment::bash_profile_d'

cookbook_file ::File.join(
  node['travis_build_environment']['home'],
  '.bash_profile.d/perlbrew.bash'
) do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o644
end

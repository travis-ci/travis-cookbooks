# frozen_string_literal: true

# Cookbook Name:: travis_build_environment
# Recipe:: environment
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

template '/etc/environment' do
  source 'etc/environment.sh.erb'
  owner 'root'
  group 'root'
  mode 0o644
end

include_recipe 'travis_build_environment::bash_profile_d'

%w[
  travis_environment
  travis_environment_ruby
  travis_environment_php
  xdg_path
].each do |profile_file|
  cookbook_file ::File.join(
    node['travis_build_environment']['home'],
    ".bash_profile.d/#{profile_file}.bash"
  ) do
    owner node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    mode 0o644
  end
end

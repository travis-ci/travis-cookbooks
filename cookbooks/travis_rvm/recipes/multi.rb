# Cookbook Name:: travis_rvm
# Recipe:: multi
# Copyright 2011-2015, Travis CI Development Team <contact@travis-ci.org>
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

include_recipe 'rvm::system'
include_recipe 'travis_java'
include_recipe 'ant'

node['travis_rvm']['rubies'].each do |ruby_name|
  rvm_ruby ruby_name do
    user node['travis_build_environment']['user']
  end

  (node['travis_rvm']['gems'] || %w(bundler rake)).each do |gem|
    rvm_shell "gem install #{gem} --no-ri --no-rdoc" do
      ruby_string ruby_name
      user node['travis_build_environment']['user']
      group node['travis_build_environment']['group']
    end
  end
end

rvm_default_ruby node['travis_rvm']['default'] do
  user node['travis_build_environment']['user']
  not_if { (node['travis_rvm']['default'] || '').empty? }
end

rvm_shell 'rvm cleanup all' do
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
end

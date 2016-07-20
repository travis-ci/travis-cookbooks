# Cookbook Name:: travis_build_environment
# Recipe:: default
# Copyright 2011-2015, Travis CI GmbH <contact+travis-cookbooks@travis-ci.org>
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

unless Array(node['travis_build_environment']['prerequisite_recipes']).empty?
  Array(node['travis_build_environment']['prerequisite_recipes']).each do |recipe_name|
    include_recipe recipe_name
  end
end

%w(
  root
  jq
  ci_user
  locale
  hostname
  security
  apt
  environment
  cleanup
).each do |internal_recipe|
  include_recipe "travis_build_environment::#{internal_recipe}"
end

unless Array(node['travis_build_environment']['postrequisite_recipes']).empty?
  Array(node['travis_build_environment']['postrequisite_recipes']).each do |recipe_name|
    include_recipe recipe_name
  end
end

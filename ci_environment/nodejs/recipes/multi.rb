#
# Cookbook Name:: node.js
# Recipe:: multi
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

include_recipe "build-essential"
include_recipe "networking_basic"

require "tmpdir"

permissions_setup = Proc.new do |resource|
  resource.owner node.travis_build_environment.user
  resource.group node.travis_build_environment.group
  resource.mode 0755
end

directory "#{node.travis_build_environment.home}/.nvm" do
  permissions_setup.call(self)
end

# Note that nvm will automatically install npm, the node package manager,
# for each installed version of node.
cookbook_file "#{node.travis_build_environment.home}/.nvm/nvm.sh" do
  permissions_setup.call(self)
end

template "/etc/profile.d/nvm.sh" do
  permissions_setup.call(self)
  source "nvm.sh.erb"
end

nvm = "source #{node.travis_build_environment.home}/.nvm/nvm.sh; nvm"

node[:nodejs][:versions].each do |version|
  bash "installing node version #{version}" do
    creates "#{node.travis_build_environment.home}/.nvm/#{version}"
    user  node.travis_build_environment.user
    group node.travis_build_environment.group
    cwd   node.travis_build_environment.home
    environment({'HOME' => "#{node.travis_build_environment.home}"})
    code  "#{nvm} install v#{version}"
  end
end

bash "make the default node" do
  user node.travis_build_environment.user
  code "#{nvm} alias default v#{node[:nodejs][:default]}"
end

node[:nodejs][:aliases].each do |existing_name, new_name|
  bash "alias node #{existing_name} => #{new_name}" do
    user node.travis_build_environment.user
    cwd  node.travis_build_environment.home
    code "#{nvm} alias #{new_name} v#{existing_name}"
  end
end

bash "clean up build artifacts & sources" do
  user node.travis_build_environment.user
  code "rm -rf #{File.join(node.travis_build_environment.home, '.nvm', 'src')}"
end

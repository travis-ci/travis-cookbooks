#
# Cookbook Name:: node.js
# Recipe:: n
# Copyright 2011, Travis CI development team
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

require "tmpdir"

permissions_setup = Proc.new do |resource|
  resource.owner "vagrant"
  resource.group "vagrant"
  resource.mode 0755
end

directory "/home/vagrant/.nvm" do
  permissions_setup.call(self)
end

# Note that nvm will automatically install npm, the node package manager,
# for each installed version of node.
cookbook_file "/home/vagrant/.nvm/nvm.sh" do
  permissions_setup.call(self)
end

cookbook_file "/etc/profile.d/nvm.sh" do
  permissions_setup.call(self)
  source "profile_entry.sh"
end

nvm = "source /home/vagrant/.nvm/nvm.sh; nvm"

node[:nodejs][:versions].each do |node|
  bash "installing node version #{node}" do
    Chef::Log.info("Installing node v#{node}")
    user "vagrant"
    not_if  "ls -l /home/vagrant/.nvm | grep \"^d\" | grep #{node}"
    code  "#{nvm} install v#{node}"
  end
end

bash "make the default node" do
  user "vagrant"
  code "#{nvm} alias default v#{node[:default]}"
end

node[:nodejs][:aliases].each do |existing_name, new_name|
  bash "alias node #{existing_name} => #{new_name}" do
    user "vagrant"
    code "#{nvm} alias #{new_name} v#{existing_name}"
  end
end

#
# Author:: Doug MacEachern <dougm@vmware.com>
# Cookbook Name:: windows
# Recipe:: git
#
# Copyright 2010, VMware, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

exe = "Git-#{node[:git][:release]}.exe"
dst = "#{node[:git][:dir]}\\#{exe}"
git = "#{node[:git][:dir]}\\bin\\git.exe"

puts "#{node[:git][:mirror]}"

directory node[:git][:dir] do
  action :create
end

remote_file dst do
  source "#{node[:git][:mirror]}/#{exe}"
  not_if { File.exists?(dst) }
end

execute "install #{exe}" do
  command "#{dst} /VERYSILENT /DIR=#{node[:git][:dir]}"
  not_if { File.exists?(git) }
end

#no command-line installer options for these, see: msysgit/share/WinGit/install.iss
execute "config core.autocrlf" do
  cwd "#{node[:git][:dir]}\\etc"
  command "#{git} config -f gitconfig core.autocrlf #{node[:git][:autocrlf]}"
end

env "PATH" do
  action :modify
  delim File::PATH_SEPARATOR
  value "#{node[:git][:dir]}\\cmd"
  only_if { node[:git][:adjust_path] == "cmd" or node[:git][:adjust_path] == "cmdtools" }
end

env "PATH" do
  action :modify
  delim File::PATH_SEPARATOR
  value "#{node[:git][:dir]}\\bin"
  only_if { node[:git][:adjust_path] == "cmdtools" }
end

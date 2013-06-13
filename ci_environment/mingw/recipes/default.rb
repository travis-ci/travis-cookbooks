#
# Author:: Doug MacEachern <dougm@vmware.com>
# Cookbook Name:: windows
# Recipe:: mingw
#
# Copyright 2011, VMware, Inc.
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

rel = "mingw-get-inst-#{node[:mingw][:release]}"
exe = "#{rel}.exe"
dst = "#{node[:mingw][:dir]}\\#{exe}"

directory node[:mingw][:dir] do
  action :create
end

remote_file dst do
  source "#{node[:mingw][:mirror]}/#{rel}/#{exe}"
  not_if { File.exists?(dst) }
end

execute "install #{exe}" do
  command "#{dst} /VERYSILENT /DIR=#{node[:mingw][:dir]}"
  not_if { File.exists?("#{node[:mingw][:dir]}\\bin\\gcc.exe") }
end

env "PATH" do
  action :modify
  delim File::PATH_SEPARATOR
  value "#{node[:mingw][:dir]}\\bin"
  only_if { true }
end

ENV["PATH"] += ";#{node[:mingw][:dir]}\\bin"

execute "install g++" do
  command "mingw-get install mingw32-gcc-g++"
  not_if { File.exists?("#{node[:mingw][:dir]}\\bin\\g++.exe") }
end

execute "install gfortran" do
  command "mingw-get install mingw32-gcc-fortran"
  not_if { File.exists?("#{node[:mingw][:dir]}\\bin\\gfortran.exe") }
end

#
# Cookbook Name:: pypy
# Recipe:: tarball
#
# Copyright 2012, Michael S Klishin & Travis CI Development Team
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

# 1. Download the tarball to /tmp
require "tmpdir"

td          = Dir.tmpdir
tmp         = File.join(td, node.pypy.tarball.filename)
tarball_dir = File.join(td, node.pypy.tarball.dirname)


remote_file(tmp) do
  source node.pypy.tarball.url

  not_if "which pypy"
end

bash "extract #{tmp}, move it to #{node.pypy.tarball.installation_dir}" do
  user "root"
  cwd  "/tmp"

  code <<-EOS
    tar xjfp #{tmp}
    rm -rf #{node.pypy.tarball.installation_dir}
    mv --force #{tarball_dir} #{node.pypy.tarball.installation_dir}
  EOS

  creates "#{node.pypy.tarball.installation_dir}/bin/pypy"
end


cookbook_file "/etc/profile.d/pypy.sh" do
  owner "root"
  group "root"
  mode 0644

  source "etc/profile.d/pypy.sh"
end

#
# Cookbook Name:: clang
# Recipe:: tarball
# Copyright 2012, Travis CI development team
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

arch = case node.clang.version
       when "3.1" then
         "x86"
       else
         "i386"
       end

filename = case [node[:platform], node[:platform_version]]
           when ["ubuntu", "11.10"] then
             "clang+llvm-#{node.clang.version}-#{arch}-linux-ubuntu-11.10.tar.bz2"
           when ["ubuntu", "12.04"] then
             "clang+llvm-#{node.clang.version}-#{arch}-linux-ubuntu-12.04.tar.gz"
           end

installation_dir = "/usr/local/clang"



# 1. Download the tarball to /tmp
require "tmpdir"

td            = Dir.tmpdir
local_tarball = File.join(td, "clang+llvm-#{node.clang.version}-#{arch}-linux-ubuntu-11.10.tar.bz2")
tarball_dir   = File.join(td, "clang+llvm-#{node.clang.version}-#{arch}-linux-ubuntu-11.10")

remote_file(local_tarball) do
  source "http://llvm.org/releases/#{node.clang.version}/#{filename}"

  not_if "which clang"
end

# 2. Extract it
# 3. Copy to /usr/local/clang, update permissions
bash "extract #{local_tarball}, move it to /usr/local" do
  user "root"
  cwd  "/tmp"

  code <<-EOS
    rm -rf #{installation_dir}
    tar jfx #{local_tarball}
    mv --force #{tarball_dir} #{installation_dir}

    chmod +x #{installation_dir}/bin/clang
    chmod +x #{installation_dir}/bin/clang++
  EOS

  creates "#{installation_dir}/bin/clang"
end

# 4. Symlink
%w(clang clang++ llvm-ld llvm-link).each do |f|
  # due to a Chef bug that prevents not_if for the link resource from doing the
  # correct thing. MK.
  bash "Remove the symlink to /usr/local/bin/#{f}" do
    user "root"
    cwd  "/tmp"

    code <<-EOS
      rm -f /usr/local/bin/#{f}
    EOS
  end

  link "/usr/local/bin/#{f}" do
    owner "root"
    group "root"
    to    "#{installation_dir}/bin/#{f}"
    not_if  "test -L /usr/local/bin/#{f}"
  end
end

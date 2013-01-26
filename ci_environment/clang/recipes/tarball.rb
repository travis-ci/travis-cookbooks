#
# Cookbook Name:: clang
# Recipe:: tarball
# Copyright 2012-2013, Travis CI Development Team <contact@travis-ci.org>
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

platform_name, ext = case [node.platform, node.platform_version]
                     when ["ubuntu", "12.04"]
                       ["#{node.platform}-#{node.platform_version.gsub(/_/, '-')}", "tar.gz"]
                     end

filename = "clang+llvm-#{node.clang.version}-#{node.clang.arch}-linux-#{platform_name}"

installation_dir = "/usr/local/clang"

# 1. Download the tarball to /tmp
require "tmpdir"

td            = Dir.tmpdir
local_tarball = File.join(td, "#{filename}.#{ext}")
tarball_dir   = File.join(td, filename)

remote_file(local_tarball) do
  source "http://llvm.org/releases/#{node.clang.version}/#{filename}.#{ext}"

  not_if "which clang"
end

tar_args = (ext =~ /gz/ ? 'zfx' : 'jfx')

# 2. Extract it
# 3. Copy to /usr/local/clang, update permissions
bash "extract #{local_tarball}, move it to /usr/local" do
  user "root"
  cwd  "/tmp"

  code <<-EOS
    rm -rf #{installation_dir}
    tar #{tar_args} #{local_tarball}
    mv --force #{tarball_dir} #{installation_dir}

    chmod +x #{installation_dir}/bin/clang
    chmod +x #{installation_dir}/bin/clang++
  EOS

  creates "#{installation_dir}/bin/clang"
end

# 4. Symlink
%w(clang clang++ llvm-ld llvm-link).each do |f|
  link "/usr/local/bin/#{f}" do
    owner "root"
    group "root"
    to    "#{installation_dir}/bin/#{f}"
  end
end

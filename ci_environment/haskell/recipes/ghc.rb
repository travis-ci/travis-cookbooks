#
# Cookbook Name:: haskell
# Recipe:: ghc
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

%w(libgmp3-dev freeglut3 freeglut3-dev).each do |pkg|
  package(pkg) do
    action :install
  end
end

link "/usr/lib/libgmp.so.3" do
  to "/usr/lib/libgmp.so"

  not_if "test -L /usr/lib/libgmp.so.3"
end


require "tmpdir"

td            = Dir.tmpdir
local_tarball = File.join(td, "ghc-#{node.ghc.version}-i386-unknown-linux.tar.bz2")

remote_file(local_tarball) do
  source "http://www.haskell.org/ghc/dist/#{node.ghc.version}/ghc-#{node.ghc.version}-#{node.ghc.arch}-unknown-linux.tar.bz2"

  not_if "test -f #{local_tarball}"
end

# 2. Extract it
# 3. configure, make install
bash "build and install GHC" do
  user "root"
  cwd  "/tmp"

  code <<-EOS
    tar jfx #{local_tarball}
    cd ghc-#{node.ghc.version}

    ./configure
    sudo make install
    cd ../
    rm -rf ghc-#{node.ghc.version}
    rm #{local_tarball}
  EOS

  creates "/usr/local/bin/ghc"
  not_if "ghc --version | grep #{node.ghc.version}"
end

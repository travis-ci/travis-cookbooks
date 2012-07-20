#
# Cookbook Name:: haskell
# Recipe:: platform
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

include_recipe "haskell::ghc"

require "tmpdir"

td            = Dir.tmpdir
local_tarball = File.join(td, "haskell-platform-#{node.haskell.platform.version}.tar.gz")

remote_file(local_tarball) do
  source "http://lambda.haskell.org/platform/download/#{node.haskell.platform.version}/haskell-platform-#{node.haskell.platform.version}.tar.gz"

  not_if "test -f #{local_tarball}"
end

# 2. Extract it
# 3. configure, make install
bash "build and install Haskell Platform" do
  user "root"
  cwd  "/tmp"

  code <<-EOS
    tar zfx #{local_tarball}
    cd `tar -tf #{local_tarball} | head -n 1`

    which ghc
    ghc --version

    ./configure
    make
    make install
    cd ../
    rm -rf `tar -tf #{local_tarball} | head -n 1`
    rm #{local_tarball}

    cabal update
    cabal install hunit c2hs
  EOS

  creates "/usr/local/bin/cabal"
end

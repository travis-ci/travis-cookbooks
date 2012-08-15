#
# Cookbook Name:: haskell
# Recipe:: platform_package
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

script "initialize cabal" do
  interpreter "bash"
  user node.travis_build_environment.user
  cwd  node.travis_build_environment.home

  environment Hash['HOME' => node.travis_build_environment.home]

  code <<-SH
  cabal update
  cabal install c2hs
  SH

  # triggered by haskell-platform installation
  action :nothing
  # until http://haskell.1045720.n5.nabble.com/Cabal-install-fails-due-to-recent-HUnit-tt5715081.html#none is resolved :( MK.
  ignore_failure true
end

package "haskell-platform" do
  action :install

  notifies :run, resources(:script => "initialize cabal")
end

cookbook_file "/etc/profile.d/cabal.sh" do
  owner node.travis_build_environment.user
  group node.travis_build_environment.group
  mode 0755
end

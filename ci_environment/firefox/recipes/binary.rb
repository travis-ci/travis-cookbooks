#
# Cookbook Name:: firefox
# Recipe:: binary
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

firefox_version = node[:firefox][:version]
firefox_dir = "/usr/local/firefox/#{firefox_version}"

directory firefox_dir do
  owner  node.travis_build_environment.user
  group  node.travis_build_environment.group
  mode   0755
  action :create
end

remote_file "/tmp/firefox.tar.bz2" do
  source "http://ftp.mozilla.org/pub/firefox/releases/#{firefox_version}/linux-x86_64/en-US/firefox-#{firefox_version}.tar.bz2"
end

bash "untar firefox" do
  user node.travis_build_environment.user
  cwd  "/usr/local/firefox/#{firefox_version}"
  code "tar xf /tmp/firefox.tar.bz2"
end

link "/usr/local/firefox/#{firefox_version}/firefox/firefox" do
  to "/usr/local/bin/firefox"
end


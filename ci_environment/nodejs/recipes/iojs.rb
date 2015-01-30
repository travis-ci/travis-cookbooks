#
# Cookbook Name:: nodejs
# Recipe:: iojs
# Copyright 2015, Travis CI Development Team <contact@travis-ci.org>
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

include_recipe "build-essential"
include_recipe "networking_basic"
include_recipe 'nodejs::multi'

require "tmpdir"

nvm = "source #{node.travis_build_environment.home}/.nvm/nvm.sh; nvm"

node[:iojs][:versions].each do |version|
  iojs_version_dir = "#{node.travis_build_environment.home}/.nvm/versions/io.js/v#{version}"

  bash "installing io.js version #{version}" do
    creates iojs_version_dir
    user  node.travis_build_environment.user
    group node.travis_build_environment.group
    cwd   node.travis_build_environment.home
    environment({'HOME' => "#{node.travis_build_environment.home}"})
    code  "#{nvm} install iojs-v#{version}"
  end

  bash "update npm to the latest version" do
    code "nvm_download -L https://npmjs.org/install.sh -o - | clean=yes sh"
  end

  node[:iojs][:default_modules].each do |mod|
    bash "install #{mod} for io.js version #{version}" do
      creates "#{iojs_version_dir}/lib/node_modules/#{mod}"
      user  node.travis_build_environment.user
      group node.travis_build_environment.group
      cwd   node.travis_build_environment.home
      environment({'HOME' => "#{node.travis_build_environment.home}"})
      code "#{nvm} use iojs-v#{version}; npm install -g #{mod}"
    end
  end
end

bash "clean up build artifacts & sources" do
  user node.travis_build_environment.user
  code "rm -rf #{File.join(node.travis_build_environment.home, '.nvm', 'src')}"
end

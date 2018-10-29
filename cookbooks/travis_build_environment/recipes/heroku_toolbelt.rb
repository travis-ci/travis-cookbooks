# frozen_string_literal: true

# Cookbook Name:: travis_build_environment
# Recipe:: heroku_toolbelt
# Copyright 2017 Travis CI GmbH
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

remote_file 'obtain heroku installer' do
  source 'https://cli-assets.heroku.com/install.sh'
  action :create
  sensitive true
  path "#{Chef::Config['file_cache_path']}/heroku_installer.sh"
  retries 3
end

execute 'install heroku' do
  command "sh #{Chef::Config['file_cache_path']}/heroku_installer.sh"
end

execute 'heroku version' do
  user node['travis_build_environment']['user']
  environment(
    'HOME' => node['travis_build_environment']['home']
  )
end

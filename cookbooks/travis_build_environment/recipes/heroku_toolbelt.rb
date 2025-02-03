# frozen_string_literal: true

# Cookbook:: travis_build_environment
# Recipe:: heroku_toolbelt
# Copyright:: 2024 Travis CI GmbH
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

if node['lsb']['codename'] == 'bionic'
  heroku_source = "https://github.com/heroku/cli/archive/refs/tags/v8.0.3.tar.gz"

  remote_file 'obtain specific heroku version release' do
    source heroku_source
    action :create
    sensitive true
    path "#{Chef::Config['file_cache_path']}/cli-8.0.3.tar.gz"
    retries 3
    notifies :write, 'log[heroku_cli_downloaded]', :immediately
  end

  log 'heroku_cli_downloaded' do
    message 'Heroku CLI archive for bionic was downloaded successfully!'
    level :info
    action :nothing
  end

  execute 'extract and install specific heroku version' do
    command <<-EOH
      mkdir -p /usr/local/lib/heroku
      tar -xzf #{Chef::Config['file_cache_path']}/cli-8.0.3.tar.gz \
          -C /usr/local/lib/heroku --strip-components=1
      chmod +x /usr/local/lib/heroku/install-standalone.sh
      /usr/local/lib/heroku/install-standalone.sh
    EOH
  end

else
  remote_file 'obtain heroku installer' do
    source 'https://cli-assets.heroku.com/install.sh'
    action :create
    sensitive true
    path "#{Chef::Config['file_cache_path']}/heroku_installer.sh"
    retries 3
    notifies :write, 'log[heroku_installer_downloaded]', :immediately
  end

  log 'heroku_installer_downloaded' do
    message 'Heroku installer script was downloaded successfully (non-bionic)!'
    level :info
    action :nothing
  end

  execute 'install heroku' do
    command "sh #{Chef::Config['file_cache_path']}/heroku_installer.sh"
  end
end

execute 'verify heroku version' do
  user node['travis_build_environment']['user']
  environment(
    'HOME' => node['travis_build_environment']['home']
  )
  command 'heroku version'
end

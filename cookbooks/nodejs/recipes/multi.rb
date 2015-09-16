#
# Cookbook Name:: nodejs
# Recipe:: multi
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

permissions_setup = Proc.new do |resource|
  resource.owner node['travis_build_environment']['user']
  resource.group node['travis_build_environment']['group']
  resource.mode 0750
end

directory "#{node.travis_build_environment.home}/.nvm" do
  permissions_setup.call(self)
end

cookbook_file "#{node.travis_build_environment.home}/.nvm/nvm.sh" do
  permissions_setup.call(self)
end

template '/etc/profile.d/nvm.sh' do
  source 'nvm.sh.erb'
  permissions_setup.call(self)
end

nvm = "source #{node.travis_build_environment.home}/.nvm/nvm.sh; nvm"

node['nodejs']['versions'].each do |version|
  bash "installing node version #{version}" do
    code "#{nvm} install v#{version}"
    creates "#{node.travis_build_environment.home}/.nvm/v#{version}"
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    cwd  node['travis_build_environment']['home']
    environment(
      'HOME' => node['travis_build_environment']['home']
    )
  end

  node['nodejs']['default_modules'].each do |mod|
    if Gem::Version.new(version) >= Gem::Version.new(mod['required'])
      bash "install #{mod[:module]} for node version #{version}" do
        code "#{nvm} use #{version}; npm install -g #{mod['module']}"
        creates "#{node['travis_build_environment']['home']}/.nvm/#{version}/lib/node_modules/#{mod['module']}"
        user node['travis_build_environment']['user']
        group node['travis_build_environment']['group']
        cwd node['travis_build_environment']['home']
        environment(
          'HOME' => node['travis_build_environment']['home']
        )
      end
    end
  end
end

bash 'make the default node' do
  code "#{nvm} alias default v#{node['nodejs']['default']}"
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  only_if { !node['nodejs']['default'].nil? && node['nodejs']['default'] != '' }
end

node['nodejs']['aliases'].each do |existing_name, new_name|
  bash "alias node #{existing_name} => #{new_name}" do
    code "#{nvm} alias #{new_name} v#{existing_name}"
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    cwd node['travis_build_environment']['home']
    environment(
      'HOME' => node['travis_build_environment']['home']
    )
  end
end

bash 'clean up build artifacts & sources' do
  code "rm -rf #{node['travis_build_environment']['home']}/.nvm/src"
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
end

def iojs?(version)
  version =~ /^iojs/
end

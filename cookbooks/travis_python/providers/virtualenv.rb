# Cookbook Name:: travis_python
# Provider:: virtualenv
#
# Copyright 2011, Opscode, Inc <legal@opscode.com>
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

require 'chef/mixin/shell_out'
require 'chef/mixin/language'
include Chef::Mixin::ShellOut

action :create do
  unless exists?
    Chef::Log.info("Creating virtualenv #{@new_resource} at #{@new_resource.path}")
    execute "virtualenv --distribute --python=#{py} #{@new_resource.path} #{maybe_system_site_packages}" do
      user new_resource.owner if new_resource.owner
      group new_resource.group if new_resource.group

      environment('VIRTUAL_ENV_DISABLE_PROMPT' => 'true')
    end
    new_resource.updated_by_last_action(true)
  end
end

action :delete do
  if exists?
    Chef::Log.info("Deleting virtualenv #{@new_resource} at #{@new_resource.path}")
    FileUtils.rm_rf(@new_resource.path)
    new_resource.updated_by_last_action(true)
  end
end

def load_current_resource
  @current_resource = Chef::Resource::TravisPythonVirtualenv.new(@new_resource.name)
  @current_resource.path(@new_resource.path)

  if exists?
    cstats = ::File.stat(@current_resource.path)
    @current_resource.owner(cstats.uid)
    @current_resource.group(cstats.gid)
  end
  @current_resource
end

private

def exists?
  (
    ::File.exist?(@current_resource.path) &&
    ::File.directory?(@current_resource.path) &&
    ::File.exist?("#{@current_resource.path}/bin/activate")
  )
end

def maybe_system_site_packages
  if @new_resource.system_site_packages
    '--system-site-packages'
  else
    ''
  end
end

def py
  if @new_resource.interpreter.to_s.downcase == 'pypy'
    ::File.join(node['pypy']['tarball']['installation_dir'], 'bin', 'pypy')
  else
    @new_resource.interpreter
  end
end

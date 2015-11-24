# Cookbook Name:: travis_python
# Provider:: pip
#
# Copyright:: 2011, Opscode, Inc <legal@opscode.com>
# Copyright:: 2011-2015, Travis CI GmbH <contact+travis-cookbooks-travis-python@travis-ci.org>
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

# the logic in all action methods mirror that of
# the Chef::Provider::Package which will make
# refactoring into core chef easy

action :install do
  # If we specified a version, and it's not the current version, move to the specified version
  if !@new_resource.version.nil? && @new_resource.version != @current_resource.version
    install_version = @new_resource.version
  # If it's not installed at all, install it
  elsif @current_resource.version.nil?
    install_version = candidate_version
  end

  if install_version
    Chef::Log.info("Installing #{@new_resource} version #{install_version}")
    status = install_package(@new_resource.package_name, install_version)
    @new_resource.updated_by_last_action(true) if status
  end
end

action :upgrade do
  if @current_resource.version != candidate_version
    orig_version = @current_resource.version || 'uninstalled'
    Chef::Log.info("Upgrading #{@new_resource} version from #{orig_version} to #{candidate_version}")
    status = upgrade_package(@new_resource.package_name, candidate_version)
    @new_resource.updated_by_last_action(true) if status
  end
end

action :remove do
  if removing_package?
    Chef::Log.info("Removing #{@new_resource}")
    remove_package(@current_resource.package_name, @new_resource.version)
    @new_resource.updated_by_last_action(true)
  end
end

def removing_package?
  if @current_resource.version.nil?
    false # nothing to remove
  elsif @new_resource.version.nil?
    true # remove any version of a package
  elsif @new_resource.version == @current_resource.version
    true # remove the version we have
  else
    false # we don't have the version we want to remove
  end
end

def expand_options(options)
  options ? " #{options}" : ''
end

# these methods are the required overrides of
# a provider that extends from Chef::Provider::Package
# so refactoring into core Chef should be easy

def load_current_resource
  @current_resource = Chef::Resource::TravisPythonPip.new(@new_resource.name)
  @current_resource.package_name(@new_resource.package_name)
  @current_resource.version(nil)

  unless current_installed_version.nil?
    @current_resource.version(current_installed_version)
  end

  @current_resource
end

def current_installed_version
  @current_installed_version ||= begin
    delimeter = /==/

    version_check_cmd = "pip freeze#{expand_virtualenv(can_haz_virtualenv(@new_resource))} | grep -i #{@new_resource.package_name}=="
    # incase you upgrade pip with pip!
    if @new_resource.package_name.eql?('pip')
      delimeter = /\s/
      version_check_cmd = 'pip --version'
    end
    p = shell_out!(version_check_cmd)
    p.stdout.split(delimeter)[1].strip
  rescue Chef::Exceptions::ShellCommandFailed, Mixlib::ShellOut::ShellCommandFailed
  end
end

def candidate_version
  @candidate_version ||= begin
    # `pip search` doesn't return versions yet
    # `pip list` may be coming soon:
    # https://bitbucket.org/ianb/pip/issue/197/option-to-show-what-version-would-be
    @new_resource.version || 'latest'
  end
end

def install_package(name, version)
  v = "==#{version}" unless version.eql?('latest')
  shell_out!("pip install#{expand_options(@new_resource.options)}#{expand_virtualenv(can_haz_virtualenv(@new_resource))} #{name}#{v}")
end

def upgrade_package(_name, version)
  v = "==#{version}" unless version.eql?('latest')
  shell_out!("pip install --upgrade#{expand_options(@new_resource.options)}#{expand_virtualenv(can_haz_virtualenv(@new_resource))} #{@new_resource.name}#{v}")
end

def remove_package(_name, _version)
  shell_out!("pip uninstall -y#{expand_options(@new_resource.options)}#{expand_virtualenv(can_haz_virtualenv(@new_resource))} #{@new_resource.name}")
end

def expand_virtualenv(virtualenv)
  virtualenv && " --environment=#{virtualenv}"
end

# TODO: remove when provider is moved into Chef core
# this allows PythonPip to work with Chef::Resource::Package
def can_haz_virtualenv(nr)
  nr.respond_to?('virtualenv') ? nr.virtualenv : nil
end

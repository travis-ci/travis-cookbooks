#
# Author:: Doug MacEachern <dougm@vmware.com>
# Cookbook:: windows
# Resource:: shortcut
#
# Copyright:: 2010-2017, VMware, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

property :target, String
property :arguments, String
property :description, String
property :cwd, String
property :iconlocation, String

load_current_value do |desired|
  require 'win32ole' if RUBY_PLATFORM =~ /mswin|mingw32|windows/

  link = WIN32OLE.new('WScript.Shell').CreateShortcut(desired.name)
  name desired.name
  target(link.TargetPath)
  arguments(link.Arguments)
  description(link.Description)
  cwd(link.WorkingDirectory)
  iconlocation(link.IconLocation)
end

action :create do
  converge_if_changed do
    converge_by "creating shortcut #{new_resource.name}" do
      link = WIN32OLE.new('WScript.Shell').CreateShortcut(new_resource.name)
      link.TargetPath = new_resource.target unless new_resource.target.nil?
      link.Arguments = new_resource.arguments unless new_resource.arguments.nil?
      link.Description = new_resource.description unless new_resource.description.nil?
      link.WorkingDirectory = new_resource.cwd unless new_resource.cwd.nil?
      link.IconLocation = new_resource.iconlocation unless new_resource.iconlocation.nil?
      # ignoring: WindowStyle, Hotkey
      link.Save
    end
  end
end

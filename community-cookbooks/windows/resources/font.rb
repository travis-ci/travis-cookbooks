#
# Author:: Sander Botman <sbotman@schubergphilis.com>
# Cookbook:: windows
# Resource:: font
#
# Copyright:: 2014-2017, Schuberg Philis BV.
# Copyright:: 2017, Chef Software, Inc.
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

property :name, String, name_property: true
property :source, String, required: false

include Windows::Helper

action :install do
  if font_exists?
    Chef::Log.debug("Not installing font: #{new_resource.name}, font already installed.")
  else
    retrieve_cookbook_font
    install_font
    del_cookbook_font
  end
end

action_class.class_eval do
  def retrieve_cookbook_font
    font_file = new_resource.name
    if new_resource.source
      remote_file font_file do
        action  :nothing
        source  "file://#{new_resource.source}"
        path    win_friendly_path(::File.join(ENV['TEMP'], font_file))
      end.run_action(:create)
    else
      cookbook_file font_file do
        action    :nothing
        cookbook  cookbook_name.to_s unless cookbook_name.nil?
        path      win_friendly_path(::File.join(ENV['TEMP'], font_file))
      end.run_action(:create)
    end
  end

  def del_cookbook_font
    file ::File.join(ENV['TEMP'], new_resource.name) do
      action :delete
    end
  end

  def install_font
    require 'win32ole' if RUBY_PLATFORM =~ /mswin|mingw32|windows/
    fonts_dir = WIN32OLE.new('WScript.Shell').SpecialFolders('Fonts')
    folder = WIN32OLE.new('Shell.Application').Namespace(fonts_dir)
    converge_by("install font #{new_resource.name}") do
      folder.CopyHere(win_friendly_path(::File.join(ENV['TEMP'], new_resource.name)))
    end
  end

  # Check to see if the font is installed
  #
  # === Returns
  # <true>:: If the font is installed
  # <false>:: If the font is not instaled
  def font_exists?
    require 'win32ole' if RUBY_PLATFORM =~ /mswin|mingw32|windows/
    fonts_dir = WIN32OLE.new('WScript.Shell').SpecialFolders('Fonts')
    ::File.exist?(win_friendly_path(::File.join(fonts_dir, new_resource.name)))
  end
end

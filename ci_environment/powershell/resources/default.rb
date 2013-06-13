#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Copyright:: Copyright (c) 2011-2012 Opscode, Inc.
# License:: Apache License, Version 2.0
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

actions :run

# Chef::Resource::Execute
attribute :command, :kind_of => String, :name_attribute => true
attribute :creates, :kind_of => String
attribute :cwd, :kind_of => String
attribute :environment, :kind_of => Hash
attribute :user, :kind_of => [ String, Integer ]
attribute :group, :kind_of => [ String, Integer ]
attribute :returns, :kind_of => [ Integer, Array ]
attribute :timeout, :kind_of => Integer

# Chef::Resource::Script
attribute :code, :kind_of => String
attribute :flags, :kind_of => String

def initialize(*args)
  super
  @action = :run
end

def interpreter
  # force 64-bit powershell from 32-bit ruby process
  if ::File.exist?("#{ENV['WINDIR']}\\sysnative\\WindowsPowershell\\v1.0\\powershell.exe")
    "#{ENV['WINDIR']}\\sysnative\\WindowsPowershell\\v1.0\\powershell.exe"
  elsif ::File.exist?("#{ENV['WINDIR']}\\system32\\WindowsPowershell\\v1.0\\powershell.exe")
    "#{ENV['WINDIR']}\\system32\\WindowsPowershell\\v1.0\\powershell.exe"
  else
    "powershell.exe"
  end
end

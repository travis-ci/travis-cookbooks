#
# Cookbook Name:: rvm
# Attributes:: default
#
# Author:: Fletcher Nichol <fnichol@nichol.ca>
#
# Copyright 2010, 2011, Fletcher Nichol
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

# ruby that will get installed and set to `rvm use default`.
default['rvm']['default_ruby']      = "ruby-1.9.3-p547"
default['rvm']['user_default_ruby'] = "ruby-1.9.3-p547"

# list of additional rubies that will be installed
default['rvm']['rubies']      = []
default['rvm']['user_rubies'] = []

# list of gems to be installed in global gemset of all rubies
_global_gems_ = [
  { 'name'    => 'bundler' }
]
default['rvm']['global_gems']       = _global_gems_.dup
default['rvm']['user_global_gems']  = _global_gems_.dup

# hash of gemsets and their list of additional gems to be installed.
default['rvm']['gems']      = Hash.new
default['rvm']['user_gems'] = Hash.new

# hash of rvmrc options
default['rvm']['rvmrc_env'] = { "rvm_gem_options" => "--no-ri --no-rdoc" }

# a hash of user hashes, each an isolated per-user RVM installation
default['rvm']['installs'] = Hash.new

# system-wide installer options
default['rvm']['installer_url']   = "https://get.rvm.io"
default['rvm']['installer_flags'] = "stable"

# extra system-wide tunables
default['rvm']['root_path']     = "/usr/local/rvm"
default['rvm']['group_id']      = 'default'
default['rvm']['group_users']   = []

# GPG key for rvm verification
default['rvm']['gpg_key']       = 'D39DC0E3'

case platform
when "redhat","centos","fedora","scientific","amazon"
  node.set['rvm']['install_pkgs']   = %w{sed grep tar gzip bzip2 bash curl git}
when "debian","ubuntu","suse"
  node.set['rvm']['install_pkgs']   = %w{sed grep tar gzip bzip2 bash curl git-core}
when "gentoo"
  node.set['rvm']['install_pkgs']   = %w{git}
when "mac_os_x", "mac_os_x_server"
  node.set['rvm']['install_pkgs']   = %w{git}
end

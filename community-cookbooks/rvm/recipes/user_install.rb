#
# Cookbook Name:: rvm
# Recipe:: user_install
#
# Copyright 2011, 2012, 2013 Fletcher Nichol
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

include_recipe "rvm"

node["rvm"]["installs"].each do |user, opts|
  # if user hash is falsy (nil, false) then we're not installing
  next unless opts

  # if user hash is not a hash (i.e. set to true), init an empty Hash
  opts = Hash.new if opts == true

  ruby_block "Conditionally add RVM gpg key" do # ~FC022 this will be fixed in the LWRP rewrite
    block do
      cmd = Mixlib::ShellOut.new('which gpg2 || which gpg')
      cmd.run_command

      if cmd.exitstatus == 0
        gpg_command = cmd.stdout.chomp

        exec = Chef::Resource::Execute.new 'Add RVM gpg key', run_context
        exec.command "#{gpg_command} --keyserver hkp://keys.gnupg.net --recv-keys #{node['rvm']['gpg_key']}"
        exec.user user['user']
        exec.environment 'HOME' => user['home']
        exec.guard_interpreter :bash
        exec.not_if "#{gpg_command} -k #{node['rvm']['gpg_key']} > /dev/null", user: user['user'], environment: { 'HOME' => user['home'] }
        exec.run_action :run
      else
        Chef::Log.info 'Skipping adding RVM key because gpg/gpg2 not installed'
      end
    end
  end

  rvm_installation(user.to_s) do
    %w(installer_url installer_flags install_pkgs rvmrc_template_source
      rvmrc_template_cookbook rvmrc_env action
    ).each do |attr|
      # if user hash attr is set, then set the resource attr
      send(attr, opts[attr]) if opts.fetch(attr, false)
    end
  end
end

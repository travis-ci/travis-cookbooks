#
# Cookbook Name:: rvm
# Provider:: rvm_installation
#
# Author:: Fletcher Nichol <fnichol@nichol.ca>
#
# Copyright 2013, Fletcher Nichol
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

require "chef/provider"
require "chef/resource/remote_file"
require "chef/resource/package"
require "chef/resource/template"
require "chef/mixin/shell_out"

class Chef

  class Provider

    class RvmInstallation < Chef::Provider

      include Chef::Mixin::ShellOut

      def load_current_resource
        @current_resource = Chef::Resource::RvmInstallation.new(new_resource.name)
        if @current_resource.installed(installed?)
          @current_resource.version(version)
        end
        @current_resource
      end

      def action_install
        converge_rvmrc
        if current_resource.installed
          Chef::Log.info("#{new_resource} #{current_resource.version} " +
            "already installed - nothing to do")
        else
          converge_install
        end
      end

      def action_force
        converge_rvmrc
      end

      def converge_rvmrc
        converge_by("manage rvmrc for #{new_resource}") { write_rvmrc }
      end

      def converge_install
        converge_by("install RVM for #{new_resource}") { install_rvm }
        Chef::Log.info("#{new_resource} #{new_resource.version} installed")
      end

      def install_rvm
        install_packages
        download_installer
        run_install_cmd

        new_resource.version(version)
      end

      def install_packages
        Array(new_resource.install_pkgs).map do |pkg|
          r = Chef::Resource::Package.new(pkg, run_context)
          r.run_action(:install)
          r
        end
      end

      def write_rvmrc
        r = Chef::Resource::Template.new(rvmrc_path, run_context)
        r.owner(new_resource.user)
        r.group(etc_user.gid)
        r.mode("0644")
        r.source(new_resource.rvmrc_template_source)
        r.cookbook(new_resource.rvmrc_template_cookbook)
        r.variables(
          :user => new_resource.user,
          :rvm_path => rvm_path,
          :rvmrc_env => new_resource.rvmrc_env
        )
        r.run_action(:create)
        r
      end

      def download_installer
        r = Chef::Resource::RemoteFile.new(rvm_installer_path, run_context)
        r.source(new_resource.installer_url)
        r.run_action(:create)
        r
      end

      def run_install_cmd
        rvm_shell_out!(%{bash #{rvm_installer_path} #{new_resource.installer_flags}})
      end

      def rvm_installer_path
        ::File.join(
          Chef::Config[:file_cache_path], "rvm-installer-#{new_resource.user}"
        )
      end

      def installed?
        cmd = rvm_shell_out(
          %{bash -c "source #{rvm_path}/scripts/rvm && type rvm"}
        )
        (cmd.exitstatus == 0 && cmd.stdout.lines.first == "rvm is a function\n")
      end

      def version
        cmd = rvm("version")
        matches = /^rvm ([\w.]+)/.match(cmd.stdout)

        if cmd.exitstatus != 0
          raise "Could not determine version for #{new_resource}, " +
            "exited (#{cmd.exitstatus})"
        end

        if matches && matches[1]
          return matches[1]
        else
          raise "Could not determine version for #{new_resource} " +
            "from version string [#{cmd.stdout}]"
        end
      end

      def rvm_shell_out(cmd)
        user = new_resource.user
        home_dir = etc_user.dir
        opts = {
          :user => user,
          :group => etc_user.gid,
          :cwd => home_dir,
          :env => { "HOME" => home_dir, "USER" => user, "TERM" => "dumb" }
        }

        Chef::Log.debug("Running [#{cmd}] with #{opts}")
        shell_out(cmd, opts)
      end

      def rvm_shell_out!(*args)
        cmd = rvm_shell_out(*args)
        cmd.error!
        cmd
      end

      def rvm(subcommand)
        rvm_shell_out(%{#{rvm_path}/bin/rvm #{subcommand}})
      end

      def rvm_path
        if new_resource.user == "root"
          "/usr/local/rvm"
        else
          ::File.join(etc_user.dir, ".rvm")
        end
      end

      def rvmrc_path
        if new_resource.user == "root"
          "/etc/rvmrc"
        else
          ::File.join(etc_user.dir, ".rvmrc")
        end
      end

      def etc_user
        Etc.getpwnam(new_resource.user)
      end
    end
  end
end

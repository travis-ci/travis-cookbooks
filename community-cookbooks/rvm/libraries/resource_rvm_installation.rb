#
# Cookbook Name:: rvm
# Resource:: rvm_installation
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

require "chef/resource"

class Chef

  class Resource

    class RvmInstallation < Chef::Resource

      state_attrs :installed, :version

      def initialize(name, run_context = nil)
        super

        @action = :install
        @allowed_actions.push(:install, :force)
        @resource_name = :rvm_installation
        @user = name
        @provider = Chef::Provider::RvmInstallation

        node_attrs = rvm_node_attrs(run_context)
        @installer_url = node_attrs["installer_url"]
        @installer_flags = node_attrs["installer_flags"]
        @install_pkgs = node_attrs["install_pkgs"]
        @rvmrc_template_source = "rvmrc.erb"
        @rvmrc_template_cookbook = "rvm"
        @rvmrc_gem_options = node_attrs["gem_options"]
        @default_rvmrc_env = Mash.new(node_attrs["rvmrc_env"])
        @rvmrc_env = node_attrs["rvmrc_env"]
        @installed = false
        @version = nil
      end

      def user(arg = nil)
        set_or_return(:user, arg, :kind_of => [String])
      end

      def installer_url(arg = nil)
        set_or_return(:installer_url, arg, :kind_of => [String])
      end

      def installer_flags(arg = nil)
        set_or_return(:installer_flags, arg, :kind_of => [String])
      end

      def install_pkgs(arg = nil)
        set_or_return(:install_pkgs, arg, :kind_of => [String])
      end

      def rvmrc_template_source(arg = nil)
        set_or_return(:rvmrc_template_source, arg, :kind_of => [String])
      end

      def rvmrc_template_cookbook(arg = nil)
        set_or_return(:rvmrc_template_cookbook, arg, :kind_of => [String])
      end

      def rvmrc_gem_options(arg = nil)
        set_or_return(:rvmrc_gem_options, arg, :kind_of => [String])
      end

      def rvmrc_env(arg = nil)
        val = arg.nil? ? nil : @default_rvmrc_env.merge(Mash.new(arg))
        set_or_return(:rvmrc_env, val, :kind_of => [Hash])
      end

      def installed(arg = nil)
        set_or_return(:installed, arg, :kind_of => [TrueClass, FalseClass])
      end

      def version(arg = nil)
        set_or_return(:version, arg, :kind_of => [String])
      end

      private

      def rvm_node_attrs(run_context)
        attrs = run_context && run_context.node && run_context.node["rvm"]
        attrs || Mash.new
      end
    end
  end
end

#
# Copyright 2015, Noah Kantrowitz
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'shellwords'

require 'chef/mixin/which'
require 'chef/provider/package'
require 'chef/resource/package'
require 'poise'

require 'poise_python/python_command_mixin'


module PoisePython
  module Resources
    # (see PythonPackage::Resource)
    # @since 1.0.0
    module PythonPackage
      # A Python snippet to hack pip a bit so `pip list --outdated` will show
      # only the things we want and will understand version requirements.
      # @api private
      PIP_HACK_SCRIPT = <<-EOH
import sys

import pip
try:
    # >= 6.0
    from pip.utils import get_installed_distributions
except ImportError:
    # <= 1.5.6
    from pip.util import get_installed_distributions

def replacement(*args, **kwargs):
    import copy, sys
    from pip._vendor import pkg_resources
    dists = []
    for raw_req in sys.argv[3:]:
        if raw_req.startswith('-'):
            continue
        req = pkg_resources.Requirement.parse(raw_req)
        dist = pkg_resources.working_set.by_key.get(req.key)
        if dist:
            # Don't mutate stuff from the global working set.
            dist = copy.copy(dist)
        else:
            # Make a fake one.
            dist = pkg_resources.Distribution(project_name=req.key, version='0')
        # Fool the .key property into using our string.
        dist._key = raw_req
        dists.append(dist)
    return dists
try:
    # For Python 2.
    get_installed_distributions.func_code = replacement.func_code
except AttributeError:
    # For Python 3.
    get_installed_distributions.__code__ = replacement.__code__

sys.exit(pip.main())
EOH

      # A `python_package` resource to manage Python installations using pip.
      #
      # @provides python_package
      # @action install
      # @action upgrade
      # @action uninstall
      # @example
      #   python_package 'django' do
      #     python '2'
      #     version '1.8.3'
      #   end
      class Resource < Chef::Resource::Package
        include PoisePython::PythonCommandMixin
        provides(:python_package)
        # Manually create matchers because #actions is unreliable.
        %i{install upgrade remove}.each do |action|
          Poise::Helpers::ChefspecMatchers.create_matcher(:python_package, action)
        end


        # @!attribute group
        #   System group to install the package.
        #   @return [String, Integer, nil]
        attribute(:group, kind_of: [String, Integer, NilClass])
        # @!attribute user
        #   System user to install the package.
        #   @return [String, Integer, nil]
        attribute(:user, kind_of: [String, Integer, NilClass])

        def initialize(*args)
          super
          # For older Chef.
          @resource_name = :python_package
          # We don't have these actions.
          @allowed_actions.delete(:purge)
          @allowed_actions.delete(:reconfig)
        end

        # Upstream attribute we don't support. Sets are an error and gets always
        # return nil.
        #
        # @api private
        # @param arg [Object] Ignored
        # @return [nil]
        def response_file(arg=nil)
          raise NoMethodError if arg
        end

        # (see #response_file)
        def response_file_variables(arg=nil)
          raise NoMethodError if arg
        end

        # (see #response_file)
        def source(arg=nil)
          raise NoMethodError if arg
        end
      end

      # The default provider for the `python_package` resource.
      #
      # @see Resource
      class Provider < Chef::Provider::Package
        include PoisePython::PythonCommandMixin
        provides(:python_package)

        # Load current and candidate versions for all needed packages.
        #
        # @api private
        # @return [Chef::Resource]
        def load_current_resource
          @current_resource = new_resource.class.new(new_resource.name, run_context)
          current_resource.package_name(new_resource.package_name)
          check_package_versions(current_resource)
          current_resource
        end

        # Populate current and candidate versions for all needed packages.
        #
        # @api private
        # @param resource [PoisePython::Resources::PythonPackage::Resource]
        #   Resource to load for.
        # @param version [String, Array<String>] Current version(s) of package(s).
        # @return [void]
        def check_package_versions(resource, version=new_resource.version)
          version_data = Hash.new {|hash, key| hash[key] = {current: nil, candidate: nil} }
          # Get the version for everything currently installed.
          list = pip_command('list').stdout
          parse_pip_list(list).each do |name, current|
            # Merge current versions in to the data.
            version_data[name][:current] = current
          end
          # Check for newer candidates.
          outdated = pip_outdated(pip_requirements(resource.package_name, version)).stdout
          parse_pip_outdated(outdated).each do |name, candidate|
            # Merge candidates in to the existing versions.
            version_data[name][:candidate] = candidate
          end
          # Populate the current resource and candidate versions. Youch this is
          # a gross mix of data flow.
          if(resource.package_name.is_a?(Array))
            @candidate_version = []
            versions = []
            [resource.package_name].flatten.each do |name|
              ver = version_data[name.downcase]
              versions << ver[:current]
              @candidate_version << ver[:candidate]
            end
            resource.version(versions)
          else
            ver = version_data[resource.package_name.downcase]
            resource.version(ver[:current])
            @candidate_version = ver[:candidate]
          end
        end

        # Install package(s) using pip.
        #
        # @param name [String, Array<String>] Name(s) of package(s).
        # @param version [String, Array<String>] Version(s) of package(s).
        # @return [void]
        def install_package(name, version)
          pip_install(name, version, upgrade: false)
        end

        # Upgrade package(s) using pip.
        #
        # @param name [String, Array<String>] Name(s) of package(s).
        # @param version [String, Array<String>] Version(s) of package(s).
        # @return [void]
        def upgrade_package(name, version)
          pip_install(name, version, upgrade: true)
        end

        # Uninstall package(s) using pip.
        #
        # @param name [String, Array<String>] Name(s) of package(s).
        # @param version [String, Array<String>] Version(s) of package(s).
        # @return [void]
        def remove_package(name, version)
          pip_command('uninstall', %w{--yes} + [name].flatten)
        end

        private

        # Convert name(s) and version(s) to an array of pkg_resources.Requirement
        # compatible strings. These are strings like "django" or "django==1.0".
        #
        # @param name [String, Array<String>] Name or names for the packages.
        # @param version [String, Array<String>] Version or versions for the
        #   packages.
        # @return [Array<String>]
        def pip_requirements(name, version)
          [name].flatten.zip([version].flatten).map do |n, v|
            v = v.to_s.strip
            if v.empty?
              # No version requirement, send through unmodified.
              n
            elsif v =~ /^\d/
              "#{n}==#{v}"
            else
              # If the first character isn't a digit, assume something fancy.
              n + v
            end
          end
        end

        # Run a pip command.
        #
        # @param pip_command [String] The pip subcommand to run (eg. install).
        # @param pip_options [Array<String>] Options for the pip command.
        # @param opts [Hash] Mixlib::ShellOut options.
        # @return [Mixlib::ShellOut]
        def pip_command(pip_command, pip_options=[], opts={})
          runner = opts.delete(:pip_runner) || %w{-m pip.__main__}
          full_cmd = if new_resource.options
            # We have to use a string for this case to be safe because the
            # options are a string and I don't want to try and parse that.
            "#{runner.join(' ')} #{pip_command} #{new_resource.options} #{Shellwords.join(pip_options)}"
          else
            # No special options, use an array to skip the extra /bin/sh.
            runner + [pip_command] + pip_options
          end
          # Set user and group.
          opts[:user] = new_resource.user if new_resource.user
          opts[:group] = new_resource.group if new_resource.group

          python_shell_out!(full_cmd, opts)
        end

        # Run `pip install` to install a package(s).
        #
        # @param name [String, Array<String>] Name(s) of package(s) to install.
        # @param version [String, Array<String>] Version(s) of package(s) to
        #   install.
        # @param upgrade [Boolean] Use upgrade mode?
        # @return [Mixlib::ShellOut]
        def pip_install(name, version, upgrade: false)
          cmd = pip_requirements(name, version)
          # Prepend --upgrade if needed.
          cmd = %w{--upgrade} + cmd if upgrade
          pip_command('install', cmd)
        end

        # Run my hacked version of `pip list --outdated` with a specific set of
        # package requirements.
        #
        # @see #pip_requirements
        # @param requirements [Array<String>] Pip-formatted package requirements.
        # @return [Mixlib::ShellOut]
        def pip_outdated(requirements)
          pip_command('list', %w{--outdated} + requirements, input: PIP_HACK_SCRIPT, pip_runner: %w{-})
        end

        # Parse the output from `pip list --outdate`. Returns a hash of package
        # key to candidate version.
        #
        # @param text [String] Output to parse.
        # @return [Hash<String, String>]
        def parse_pip_outdated(text)
          text.split(/\n/).inject({}) do |memo, line|
            # Example of a line:
            # boto (Current: 2.25.0 Latest: 2.38.0 [wheel])
            if md = line.match(/^(\S+)\s+\(.*?latest:\s+([^\s,]+).*\)$/i)
              memo[md[1].downcase] = md[2]
            else
              Chef::Log.debug("[#{new_resource}] Unparsable line in pip outdated: #{line}")
            end
            memo
          end
        end

        # Parse the output from `pip list`. Returns a hash of package key to
        # current version.
        #
        # @param text [String] Output to parse.
        # @return [Hash<String, String>]
        def parse_pip_list(text)
          text.split(/\n/).inject({}) do |memo, line|
            # Example of a line:
            # boto (2.25.0)
            if md = line.match(/^(\S+)\s+\(([^\s,]+).*\)$/i)
              memo[md[1].downcase] = md[2]
            else
              Chef::Log.debug("[#{new_resource}] Unparsable line in pip list: #{line}")
            end
            memo
          end
        end

      end
    end
  end
end

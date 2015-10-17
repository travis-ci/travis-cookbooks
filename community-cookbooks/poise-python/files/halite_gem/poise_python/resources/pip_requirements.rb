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

require 'chef/provider'
require 'chef/resource'
require 'poise'

require 'poise_python/python_command_mixin'


module PoisePython
  module Resources
    # (see PipRequirements::Resource)
    # @since 1.0.0
    module PipRequirements
      # A `pip_requirements` resource to install packages from a requirements.txt
      # file using pip.
      #
      # @provides pip_requirements
      # @action install
      # @action upgrade
      # @example
      #   pip_requirements '/opt/myapp/requirements.txt'
      class Resource < Chef::Resource
        include PoisePython::PythonCommandMixin
        provides(:pip_requirements)
        actions(:install, :upgrade)

        # @!attribute path
        #   Path to the requirements file, or a folder containing the
        #   requirements file.
        #   @return [String]
        attribute(:path, kind_of: String, name_attribute: true)
      end

      # The default provider for `pip_requirements`.
      #
      # @see Resource
      # @provides pip_requirements
      class Provider < Chef::Provider
        include Poise
        include PoisePython::PythonCommandMixin
        provides(:pip_requirements)

        # The `install` action for the `pip_requirements` resource.
        #
        # @return [void]
        def action_install
          install_requirements(upgrade: false)
        end

        # The `upgrade` action for the `pip_requirements` resource.
        #
        # @return [void]
        def action_upgrade
          install_requirements(upgrade: true)
        end

        private

        # Run an install --requirements command and parse the output.
        #
        # @param upgrade [Boolean] If we should use the --upgrade flag.
        # @return [void]
        def install_requirements(upgrade: false)
          cmd = %w{-m pip.__main__ install}
          cmd << '--upgrade' if upgrade
          cmd << '--requirement'
          cmd << requirements_path
          output = python_shell_out!(cmd).stdout
          if output.include?('Successfully installed')
            new_resource.updated_by_last_action(true)
          end
        end

        # Find the true path to the requirements file.
        #
        # @return [String]
        def requirements_path
          if ::File.directory?(new_resource.path)
            ::File.join(new_resource.path, 'requirements.txt')
          else
            new_resource.path
          end
        end

      end
    end
  end
end

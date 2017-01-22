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

require 'tempfile'

require 'chef/resource'
require 'poise'


module PoisePython
  module Resources
    # (see PythonRuntimePip::Resource)
    # @since 1.0.0
    # @api private
    module PythonRuntimePip
      # URL for the default get-pip.py script.
      DEFAULT_GET_PIP_URL = 'https://bootstrap.pypa.io/get-pip.py'

      # A `python_runtime_pip` resource to install/upgrade pip itself. This is
      # used internally by `python_runtime` and is not intended to be a public
      # API.
      #
      # @provides python_runtime_pip
      # @action install
      # @action uninstall
      class Resource < Chef::Resource
        include Poise(parent: :python_runtime)
        provides(:python_runtime_pip)
        actions(:install, :uninstall)

        # @!attribute version
        #   Version of pip to install. Only kind of works due to
        #   https://github.com/pypa/pip/issues/1087.
        #   @return [String]
        attribute(:version, kind_of: String)
        # @!attribute get_pip_url
        #   URL to the get-pip.py script. Defaults to pulling it from pypa.io.
        #   @return [String]
        attribute(:get_pip_url, kind_of: String, default: DEFAULT_GET_PIP_URL)
      end

      # The default provider for `python_runtime_pip`.
      #
      # @see Resource
      # @provides python_runtime_pip
      class Provider < Chef::Provider
        include Poise
        provides(:python_runtime_pip)

        # @api private
        def load_current_resource
          super.tap do |current_resource|
            # Try to find the current version if possible.
            current_resource.version(pip_version)
          end
        end

        # The `install` action for the `python_runtime_pip` resource.
        #
        # @return [void]
        def action_install
          if current_resource.version
            install_pip
          else
            bootstrap_pip
          end
        end

        # The `uninstall` action for the `python_runtime_pip` resource.
        #
        # @return [void]
        def action_uninstall
          notifying_block do
            python_package 'pip' do
              action :uninstall
            end
          end
        end

        private

        # Bootstrap pip using get-pip.py.
        #
        # @return [void]
        def bootstrap_pip
          # Always updated if we have hit this point.
          new_resource.updated_by_last_action(true)
          # Pending https://github.com/pypa/pip/issues/1087.
          if new_resource.version
            Chef::Log.warn("pip does not support bootstrapping a specific version, see https://github.com/pypa/pip/issues/1087.")
          end
          # Use a temp file to hold the installer.
          Tempfile.create(['get-pip', '.py']) do |temp|
            # Download the get-pip.py.
            get_pip = Chef::HTTP.new(new_resource.get_pip_url).get('')
            # Write it to the temp file.
            temp.write(get_pip)
            # Close the file to flush it.
            temp.close
            # Run the install. This probably needs some handling for proxies et
            # al. Disable setuptools and wheel as we will install those later.
            # Use the environment vars instead of CLI arguments so I don't have
            # to deal with bootstrap versions that don't support --no-wheel.
            shell_out!([new_resource.parent.python_binary, temp.path], environment: new_resource.parent.python_environment.merge('PIP_NO_SETUPTOOLS' => '1', 'PIP_NO_WHEEL' => '1'))
          end
          new_pip_version = pip_version
          if new_resource.version && new_pip_version != new_resource.version
            # We probably want to downgrade, which is silly but ¯\_(ツ)_/¯.
            # Can be removed once https://github.com/pypa/pip/issues/1087 is fixed.
            current_resource.version(new_pip_version)
            install_pip
          end
        end

        # Upgrade (or downgrade) pip using itself. Should work back at least
        # pip 1.5.
        #
        # @return [void]
        def install_pip
          if new_resource.version
            # Already up to date, we're done here.
            return if current_resource.version == new_resource.version
          else
            # We don't wany a specific version, so just make a general check.
            return if current_resource.version
          end

          notifying_block do
            # Use pip to upgrade (or downgrade) itself.
            python_package 'pip' do
              action :upgrade
              version new_resource.version if new_resource.version
            end
          end
        end

        # Find the version of pip currently installed in this Python runtime.
        # Returns nil if not installed.
        #
        # @return [String, nil]
        def pip_version
          cmd = shell_out([new_resource.parent.python_binary, '-m', 'pip.__main__', '--version'], environment: new_resource.parent.python_environment)
          if cmd.error?
            # Not installed, probably.
            nil
          else
            cmd.stdout[/pip ([\d.a-z]+)/, 1]
          end
        end

      end
    end
  end
end

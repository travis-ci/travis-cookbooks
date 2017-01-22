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


module PoisePython
  module Resources
    # (see PythonRuntimeTest::Resource)
    # @since 1.0.0
    # @api private
    module PythonRuntimeTest
      # A `python_runtime_test` resource for integration testing of this
      # cookbook. This is an internal API and can change at any time.
      #
      # @provides python_runtime_test
      # @action run
      class Resource < Chef::Resource
        include Poise
        provides(:python_runtime_test)
        actions(:run)

        attribute(:version, kind_of: String, name_attribute: true)
        attribute(:runtime_provider, kind_of: Symbol)
        attribute(:path, kind_of: String, default: lazy { default_path })

        def default_path
          ::File.join('', 'root', "python_test_#{name}")
        end
      end

      # The default provider for `python_runtime_test`.
      #
      # @see Resource
      # @provides python_runtime_test
      class Provider < Chef::Provider
        include Poise
        provides(:python_runtime_test)

        # The `run` action for the `python_runtime_test` resource.
        #
        # @return [void]
        def action_run
          notifying_block do
            # Top level directory for this test.
            directory new_resource.path

            # Install and log the version.
            python_runtime new_resource.name do
              provider new_resource.runtime_provider if new_resource.runtime_provider
              version new_resource.version
            end
            test_version

            # Test python_package.
            python_package 'sqlparse remove before' do
              action :remove
              package_name 'sqlparse'
              python new_resource.name
            end
            test_import('sqlparse', 'sqlparse_before')
            python_package 'sqlparse' do
              python new_resource.name
              notifies :create, sentinel_file('sqlparse'), :immediately
            end
            test_import('sqlparse', 'sqlparse_mid')
            python_package 'sqlparse again' do
              package_name 'sqlparse'
              python new_resource.name
              notifies :create, sentinel_file('sqlparse2'), :immediately
            end
            python_package 'sqlparse remove after' do
              action :remove
              package_name 'sqlparse'
              python new_resource.name
            end
            test_import('sqlparse', 'sqlparse_after')

            # Use setuptools to test something that should always be installed.
            python_package 'setuptools' do
              python new_resource.name
              notifies :create, sentinel_file('setuptools'), :immediately
            end

            # Multi-package install.
            python_package ['pep8', 'pytz'] do
              python new_resource.name
            end
            test_import('pep8')
            test_import('pytz')

            # Create a virtualenv.
            python_virtualenv ::File.join(new_resource.path, 'venv') do
              python new_resource.name
            end

            # Install a package inside a virtualenv.
            python_package 'Pytest' do
              virtualenv ::File.join(new_resource.path, 'venv')
            end
            test_import('pytest')
            test_import('pytest', 'pytest_venv', python: nil, virtualenv: ::File.join(new_resource.path, 'venv'))

            # Create and install a requirements file.
            file ::File.join(new_resource.path, 'requirements.txt') do
              content <<-EOH
requests==2.7.0
six==1.8.0
EOH
            end
            pip_requirements ::File.join(new_resource.path, 'requirements.txt') do
              python new_resource.name
            end
            test_import('requests')
            test_import('six')
          end
        end

        def sentinel_file(name)
          file ::File.join(new_resource.path, "sentinel_#{name}") do
            action :nothing
          end
        end

        private

        def test_version(python: new_resource.name, virtualenv: nil)
          # Only queue up this resource once, the ivar is just for tracking.
          @python_version_test ||= file ::File.join(new_resource.path, 'python_version.py') do
            user 'root'
            group 'root'
            mode '644'
            content <<-EOH
import sys, platform
open(sys.argv[1], 'w').write(platform.python_version())
EOH
          end

          python_execute "#{@python_version_test.path} #{::File.join(new_resource.path, 'version')}" do
            python python if python
            virtualenv virtualenv if virtualenv
          end
        end

        def test_import(name, path=name, python: new_resource.name, virtualenv: nil)
          # Only queue up this resource once, the ivar is just for tracking.
          @python_import_test ||= file ::File.join(new_resource.path, 'import_version.py') do
            user 'root'
            group 'root'
            mode '644'
            content <<-EOH
try:
    import sys
    mod = __import__(sys.argv[1])
    open(sys.argv[2], 'w').write(mod.__version__)
except ImportError:
    pass
EOH
          end

          python_execute "#{@python_import_test.path} #{name} #{::File.join(new_resource.path, "import_#{path}")}" do
            python python if python
            virtualenv virtualenv if virtualenv
          end
        end

      end
    end
  end
end

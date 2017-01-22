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

require 'chef/resource'
require 'chef/provider'
require 'poise'


module PoiseLanguages
  module Scl
    # A `poise_language_scl` resource to manage installing a language from
    # SCL packages. This is an internal implementation detail of
    # poise-languages.
    #
    # @api private
    # @since 1.0
    # @provides poise_languages_scl
    # @action install
    # @action uninstall
    class Resource < Chef::Resource
      include Poise
      provides(:poise_languages_scl)
      actions(:install, :upgrade, :uninstall)

      # @!attribute package_name
      #   Name of the SCL package for the language.
      #   @return [String]
      attribute(:package_name, kind_of: String, name_attribute: true)
      attribute(:dev_package, kind_of: [String, NilClass])
      # @!attribute url
      #   URL to the SCL repository package for the language.
      #   @return [String]
      attribute(:url, kind_of: String, required: true)
      attribute(:version, kind_of: [String, NilClass])
      # @!attribute parent
      #   Resource for the language runtime. Used only for messages.
      #   @return [Chef::Resource]
      attribute(:parent, kind_of: Chef::Resource, required: true)
    end

    # The default provider for `poise_languages_scl`.
    #
    # @api private
    # @since 1.0
    # @see Resource
    # @provides poise_languages_scl
    class Provider < Chef::Provider
      include Poise
      provides(:poise_languages_scl)

      # The `install` action for the `poise_languages_scl` resource.
      #
      # @return [void]
      def action_install
        notifying_block do
          install_scl_utils
          install_scl_repo_package
          flush_yum_cache
          install_scl_package(:install)
          install_scl_devel_package(:install) if new_resource.dev_package
        end
      end

      # The `upgrade` action for the `poise_languages_scl` resource.
      #
      # @return [void]
      def action_upgrade
        notifying_block do
          install_scl_utils
          install_scl_repo_package
          flush_yum_cache
          install_scl_package(:upgrade)
          install_scl_devel_package(:upgrade) if new_resource.dev_package
        end
      end

      # The `uninstall` action for the `poise_languages_scl` resource.
      #
      # @return [void]
      def action_uninstall
        notifying_block do
          uninstall_scl_utils
          uninstall_scl_repo_package
          uninstall_scl_devel_package if new_resource.dev_package
          uninstall_scl_package
          flush_yum_cache
        end
      end

      private

      def install_scl_utils
        package 'scl-utils' do
          action :upgrade # This shouldn't be a problem. Famous last words.
        end
      end

      def install_scl_repo_package
        rpm_package 'rhscl-' + new_resource.package_name do
          source new_resource.url
        end
      end

      def flush_yum_cache
        ruby_block 'flush_yum_cache' do
          block do
            # Equivalent to flush_cache after: true
            Chef::Provider::Package::Yum::YumCache.instance.reload
          end
        end
      end

      def install_scl_package(action)
        yum_package new_resource.package_name do
          action action
          version new_resource.version
        end
      end

      def install_scl_devel_package(action)
        yum_package new_resource.dev_package do
          action action
        end
      end

      def uninstall_scl_utils
        install_scl_utils.tap do |r|
          r.action(:remove)
        end
      end

      def uninstall_scl_repo_package
        install_scl_repo_package.tap do |r|
          r.action(:remove)
        end
      end

      def uninstall_scl_package
        install_scl_package(:remove)
      end

      def uninstall_scl_devel_package
        install_scl_devel_package(:remove)
      end

    end
  end
end

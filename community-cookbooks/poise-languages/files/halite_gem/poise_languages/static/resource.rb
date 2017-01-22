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
  module Static
    # A `poise_languages_static` resource to manage installing a language from
    # static binary archives. This is an internal implementation detail of
    # poise-languages.
    #
    # @api private
    # @since 1.1.0
    # @provides poise_languages_static
    # @action install
    # @action uninstall
    class Resource < Chef::Resource
      include Poise
      provides(:poise_languages_static)
      actions(:install, :uninstall)

      # @!attribute path
      #   Directory to install to.
      #   @return [String]
      attribute(:path, kind_of: String, name_attribute: true)
      # @!attribute source
      #   URL to download from.
      #   @return [String]
      attribute(:source, kind_of: String, required: true)
      # @!attribute strip_components
      #   Value to pass to tar --strip-components.
      #   @return [String, Integer, nil]
      attribute(:strip_components, kind_of: [String, Integer, NilClass], default: 1)

      def cache_path
        @cache_path ||= ::File.join(Chef::Config[:file_cache_path], source.split(/\//).last)
      end
    end

    # The default provider for `poise_languages_static`.
    #
    # @api private
    # @since 1.0
    # @see Resource
    # @provides poise_languages_static
    class Provider < Chef::Provider
      include Poise
      provides(:poise_languages_static)

      # The `install` action for the `poise_languages_static` resource.
      #
      # @return [void]
      def action_install
        notifying_block do
          install_utils unless node.platform_family?('mac_os_x', 'windows')
          create_directory
          download_archive
          # Unpack is handled as a notification from download_archive.
        end
      end

      # The `uninstall` action for the `poise_languages_static` resource.
      #
      # @return [void]
      def action_uninstall
        notifying_block do
          delete_archive
          delete_directory
        end
      end

      private

      def install_utils
        package [].tap {|utils|
          utils << 'tar' if new_resource.cache_path =~ /\.t(ar|gz|bz|xz)/
          utils << 'bzip2' if new_resource.cache_path =~ /\.t?bz/
          # This probably won't work on RHEL?
          utils << 'xz-utils' if new_resource.cache_path =~ /\.t?xz/
        }
      end

      def create_directory
        directory new_resource.path do
          user 0
          group 0
          mode '755'
        end
      end

      def download_archive
        unpack_resource = unpack_archive
        remote_file new_resource.cache_path do
          source new_resource.source
          owner 0
          group 0
          mode '644'
          notifies :run, unpack_resource, :immediately
        end
      end

      def unpack_archive
        # Build up the unpack command. Someday this will probably need to
        # support unzip too.
        cmd = %w{tar}
        cmd << "--strip-components=#{new_resource.strip_components}" if new_resource.strip_components && new_resource.strip_components > 0
        cmd << if new_resource.cache_path =~ /\.t?gz/
          '-xzvf'
        elsif new_resource.cache_path =~ /\.t?bz/
          '-xjvf'
        elsif new_resource.cache_path =~ /\.t?xz/
          '-xJvf'
        else
          '-xvf'
        end
        cmd << new_resource.cache_path

        execute 'unpack archive' do
          # Run via notification from #download_archive.
          action :nothing
          command cmd
          cwd new_resource.path
        end
      end

      def delete_archive
        file new_resource.cache_path do
          action :delete
        end
      end

      def delete_directory
        directory new_resource.path do
          action :delete
          recursive true
        end
      end

    end
  end
end

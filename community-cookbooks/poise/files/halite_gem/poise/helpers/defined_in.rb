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

require 'poise/error'
require 'poise/utils'


module Poise
  module Helpers
    # A mixin to track where a resource or provider was defined. This can
    # provide either the filename of the class or the cookbook it was defined in.
    #
    # @since 2.0.0
    # @example
    #   class MyProvider < Chef::provider
    #     include Poise::Helpers::DefinedIn
    #
    #     def action_create
    #       template '...' do
    #         # ...
    #         cookbook new_resource.poise_defined_in
    #       end
    #     end
    #   end
    module DefinedIn
      # Wrapper for {.poise_defined_in_cookbook} to pass the run context for you.
      #
      # @see .poise_defined_in_cookbook
      # @param file [String, nil] Optional file path to check instead of the path
      #   this class was defined in.
      # @return [String]
      def poise_defined_in_cookbook(file=nil)
        self.class.poise_defined_in_cookbook(run_context, file)
      end

      # @!classmethods
      module ClassMethods
        # The file this class or module was defined in, or nil if it isn't found.
        #
        # @return [String]
        def poise_defined_in
          raise Poise::Error.new("Unable to determine location of #{self.name}") unless @poise_defined_in
          @poise_defined_in
        end

        # The cookbook this class or module was defined in. Can pass a file to
        # check that instead.
        #
        # @param run_context [Chef::RunContext] Run context to check cookbooks in.
        # @param file [String, nil] Optional file path to check instead of the
        #   path this class was defined in.
        # @return [String]
        def poise_defined_in_cookbook(run_context, file=nil)
          file ||= poise_defined_in
          Chef::Log.debug("[#{self.name}] Checking cookbook name for #{file}")
          Poise::Utils.find_cookbook_name(run_context, file).tap do |cookbook|
            Chef::Log.debug("[#{self.name}] found cookbook #{cookbook.inspect}")
          end
        end

        # Record that the class/module was defined. Called automatically by Ruby
        # for all normal cases.
        #
        # @param caller_array [Array<String>] A strack trace returned by #caller.
        # @return [void]
        def poise_defined!(caller_array)
          # Only try to set this once.
          return if @poise_defined_in
          # Path to ignore, assumes Halite transformation which I'm not thrilled
          # about.
          poise_libraries = File.expand_path('../..', __FILE__)
          # Parse out just the filenames.
          caller_array = caller_array.map {|line| line.split(/:/, 2).first }
          # Find the first non-poise line.
          caller_path = caller_array.find do |line|
            !line.start_with?(poise_libraries)
          end
          Chef::Log.debug("[#{self.name}] Recording poise_defined_in as #{caller_path}")
          @poise_defined_in = caller_path
        end

        # @api private
        def inherited(klass)
          super
          klass.poise_defined!(caller)
        end

        def included(klass)
          super
          klass.extend(ClassMethods)
          klass.poise_defined!(caller)
        end
      end

      extend ClassMethods
    end
  end
end

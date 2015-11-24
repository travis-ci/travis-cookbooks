#
# Cookbook Name:: rvm
# Library:: Chef::RVM::RecipeHelpers
#
# Author:: Fletcher Nichol <fnichol@nichol.ca>
#
# Copyright 2011, Fletcher Nichol
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

class Chef
  module RVM
    module RecipeHelpers

      def install_rubies(opts = {})
        # install additional rubies
        opts[:rubies].each do |rubie|
          if rubie.is_a?(Hash)
            ruby = rubie.fetch("version")
            ruby_patch = rubie.fetch("patch", nil)
            ruby_rubygems_version = rubie.fetch("rubygems_version", nil)
          else
            ruby = rubie
            ruby_patch = nil
            ruby_rubygems_version = nil
          end

          rvm_ruby ruby do
            patch            ruby_patch
            user             opts[:user]
            rubygems_version ruby_rubygems_version
          end
        end

        # set a default ruby
        rvm_default_ruby opts[:default_ruby] do
          user  opts[:user]
        end

        # install global gems
        opts[:global_gems].each do |gem|
          rvm_global_gem gem[:name] do
            user      opts[:user]
            [:version, :action, :options, :source].each do |attr|
              send(attr, gem[attr]) if gem[attr]
            end
          end
        end

        # install additional gems
        opts[:gems].each_pair do |rstring, gems|
          rvm_environment rstring do
            user  opts[:user]
          end

          gems.each do |gem|
            rvm_gem gem[:name] do
              ruby_string   rstring
              user          opts[:user]
              [:version, :action, :options, :source].each do |attr|
                send(attr, gem[attr]) if gem[attr]
              end
            end
          end
        end
      end
    end
  end
end

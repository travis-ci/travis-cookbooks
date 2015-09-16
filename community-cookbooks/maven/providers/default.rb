#
# Cookbook Name:: maven
# Provider:: default
#
# Author:: Bryan W. Berry <bryan.berry@gmail.com>
# Copyright 2011-2013, Opscode Inc.
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

require 'chef/mixin/shell_out'
require 'chef/mixin/checksum'
require 'fileutils'

include Chef::Mixin::ShellOut
include Chef::Mixin::Checksum

def create_command_string(artifact_file, new_resource)
  group_id = '-DgroupId=' + new_resource.group_id
  artifact_id = '-DartifactId=' + new_resource.artifact_id
  version = '-Dversion=' + new_resource.version
  dest = '-Ddest=' + artifact_file
  repos = '-DremoteRepositories=' + new_resource.repositories.join(',')
  packaging = '-Dpackaging=' + new_resource.packaging
  classifier = '-Dclassifier=' + new_resource.classifier if new_resource.classifier
  plugin_version = '2.4'
  plugin = "org.apache.maven.plugins:maven-dependency-plugin:#{plugin_version}:get"
  transitive = '-Dtransitive=' + new_resource.transitive.to_s
  %Q{mvn #{plugin} #{group_id} #{artifact_id} #{version} #{packaging} #{classifier} #{dest} #{repos} #{transitive}}
end

def get_mvn_artifact(action, new_resource)
  if action == 'put'
    artifact_file_name = "#{new_resource.name}.#{new_resource.packaging}"
  else
    artifact_file_name = if new_resource.classifier.nil?
                           "#{new_resource.artifact_id}-#{new_resource.version}.#{new_resource.packaging}"
                         else
                           "#{new_resource.artifact_id}-#{new_resource.version}-#{new_resource.classifier}.#{new_resource.packaging}"
                         end
  end

  Dir.mktmpdir('chef_maven_lwrp') do |tmp_dir|
    tmp_file = ::File.join(tmp_dir, artifact_file_name)
    shell_out!(create_command_string(tmp_file, new_resource))
    dest_file = ::File.join(new_resource.dest, artifact_file_name)

    unless ::File.exists?(dest_file) && checksum(tmp_file) == checksum(dest_file)
      directory new_resource.dest do
        recursive true
        mode '0755'
      end.run_action(:create)

      FileUtils.cp(tmp_file, dest_file, :preserve => true)

      file dest_file do
        owner new_resource.owner
        group new_resource.owner
        mode new_resource.mode
      end.run_action(:create)

      new_resource.updated_by_last_action(true)
    end
  end
end

action :install do
  converge_by("Install #{new_resource}") do
    get_mvn_artifact('install', new_resource)
  end
end

action :put do
  converge_by("Put #{new_resource}") do
    get_mvn_artifact('put', new_resource)
  end
end

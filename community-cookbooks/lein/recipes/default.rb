#
# Cookbook Name:: lein
# Recipe:: default
#
# Copyright 2010, Opscode, Inc.
# Copyright 2011-2013, Travis CI Development Team <contact@travis-ci.org>
# Copyright 2014-2015, OpenSensors Development Team <team@opensensors.io>
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

include_recipe "java"

jar_dir  = File.join(node.leiningen.home, ".lein")
jar_file = File.join(jar_dir, "self-installs", "#{jar_dir}/leiningen-#{node.leiningen.version}-standalone.jar")

[jar_dir, File.join(jar_dir, "self-installs")].each do |dir|
  directory dir do
    owner     node.leiningen.user
    group     node.leiningen.user
    recursive true

    action    :create
  end
end

ruby_block "lein-system-wide" do
  block do
    rc = Chef::Util::FileEdit.new(node.leiningen.bin_path)
    rc.search_file_replace_line(/^LEIN_JAR=.*/, "LEIN_JAR=#{jar_file}")
    rc.write_file
  end
  action :nothing
end

script "run lein self-install" do
  interpreter "bash"
  # version forces leiningen to download core plugins like lein-newnew
  code        "#{node.leiningen.bin_path} self-install && #{node.leiningen.bin_path} version"

  cwd        node.leiningen.home
  user       node.leiningen.user
  environment({
      "HOME" => node.leiningen.home,
      "USER" => node.leiningen.user,
      "LEIN_JVM_OPTS" => "-Xms16m -Xmx256m"
    })

  not_if "ls #{jar_file}"

  action :nothing
end

remote_file node.leiningen.bin_path do
  source   node.leiningen.install_script
  mode     0755


  notifies :create, resources(:ruby_block => "lein-system-wide"), :immediately
  notifies :run,    resources(:script     => "run lein self-install")

  not_if "grep -qx 'export LEIN_VERSION=\"#{node.leiningen.version}\"' #{node.leiningen.bin_path}"
end

#
# Cookbook Name:: leiningen::lein2x
# Recipe:: default
#
# Copyright 2010, Opscode, Inc.
# Copyright 2011-2013, Travis CI Development Team <contact@travis-ci.org>
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

jar_dir  = File.join(node.travis_build_environment.home, ".lein")
jar_file = File.join(jar_dir, "self-installs", "#{jar_dir}/leiningen-#{node[:leiningen][:lein2][:version]}-standalone.jar")

[jar_dir, File.join(jar_dir, "self-installs")].each do |dir|
  directory dir do
    owner     node.travis_build_environment.user
    group     node.travis_build_environment.group
    recursive true

    action    :create
  end
end

ruby_block "lein2-system-wide" do
  block do
    rc = Chef::Util::FileEdit.new("/usr/local/bin/lein2")
    rc.search_file_replace_line(/^LEIN_JAR=.*/, "LEIN_JAR=#{jar_file}")
    rc.write_file
  end
  action :nothing
end

script "run lein2 self-install" do
  interpreter "bash"
  # version forces leiningen to download core plugins like lein-newnew
  code        "/usr/local/bin/lein2 self-install && /usr/local/bin/lein2 version"

  cwd        node.travis_build_environment.home
  user       node.travis_build_environment.user
  environment({ "HOME" => node.travis_build_environment.home, "USER" => node.travis_build_environment.user, "LEIN_JVM_OPTS" => "-Xms16m -Xmx256m" })

  not_if "ls #{jar_file}"

  action :nothing
end

remote_file "/usr/local/bin/lein2" do
  source   node[:leiningen][:lein2][:install_script]
  owner    node.travis_build_environment.user
  group    node.travis_build_environment.group
  mode     0755


  notifies :create, resources(:ruby_block => "lein2-system-wide"), :immediately
  notifies :run,    resources(:script     => "run lein2 self-install")

  not_if "grep -qx 'export LEIN_VERSION=\"#{node[:leiningen][:lein2][:version]}\"' /usr/local/bin/lein"
end

# workaround a nasty NPE in Lein 2.0 preview1 when lein2 is ran outside
# of project and profiles.clj has no :plugins entry.
# See https://groups.google.com/d/msg/clojure/jRRR9JlppNQ/lRJPB3b-4ycJ. MK.
cookbook_file File.join(jar_dir, "profiles.clj") do
  owner    node.travis_build_environment.user
  group    node.travis_build_environment.group
  mode     0644

  subscribes :create, resources(:directory => jar_dir)

  action :nothing
end

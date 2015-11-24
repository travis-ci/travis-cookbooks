#
# Cookbook Name:: travis_build_environment
# Recipe:: non_privileged_user
# Copyright 2011-2013, Travis CI Development Team <contact@travis-ci.org>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.


cookbook_file "/etc/profile.d/travis_environment.sh" do
  owner node.travis_build_environment.user
  group node.travis_build_environment.group
  mode 0755

  source "ci_user/travis_environment.sh"
end


cookbook_file "#{node.travis_build_environment.home}/.gemrc" do
  owner node.travis_build_environment.user
  group node.travis_build_environment.group
  mode 0755

  source "ci_user/dot_gemrc.yml"
end


cookbook_file "#{node.travis_build_environment.home}/.erlang.cookie" do
  owner node.travis_build_environment.user
  group node.travis_build_environment.group
  mode 0400

  source "ci_user/dot_erlang_dot_cookie"
end


template "#{node.travis_build_environment.home}/.bashrc" do
  owner node.travis_build_environment.user
  group node.travis_build_environment.group
  mode 0755

  source "ci_user/dot_bashrc.sh.erb"
end


template "#{node.travis_build_environment.home}/.travis_ci_environment.yml" do
  owner node.travis_build_environment.user
  group node.travis_build_environment.group
  mode 0755

  source "ci_user/ci_environment_metadata.yml.erb"
end


directory "#{node.travis_build_environment.home}/.ssh" do
  owner  node.travis_build_environment.user
  group  node.travis_build_environment.group
  mode   "0755"

  action :create
end


cookbook_file "#{node.travis_build_environment.home}/.ssh/known_hosts" do
  owner node.travis_build_environment.user
  group node.travis_build_environment.group
  mode  0600

  source "ci_user/known_hosts"
end


directory "#{node.travis_build_environment.home}/builds" do
  owner node.travis_build_environment.user
  group node.travis_build_environment.group
  mode "0755"
  action :create
end


mount "#{node.travis_build_environment.home}/builds" do
  fstype   "tmpfs"
  device   "/dev/null" # http://tickets.opscode.com/browse/CHEF-1657, doesn't seem to be included in 0.10.0
  options  "defaults,size=#{node.travis_build_environment.builds_volume_size},noatime"
  action   [:mount, :enable]
  only_if { node.travis_build_environment[:use_tmpfs_for_builds] }
end


directory(File.join(node.travis_build_environment.home, ".m2")) do
  owner  node.travis_build_environment.user
  group  node.travis_build_environment.group
  mode   0755
end

maven_user_settings = File.join(node.travis_build_environment.home, ".m2", "settings.xml")
cookbook_file(maven_user_settings) do
  owner  node.travis_build_environment.user
  group  node.travis_build_environment.group
  mode   0644

  source "ci_user/maven_user_settings.xml"
end


# link /home/vagrant for those poor projects that absolutely depend on that legacy
# home directory to be present. MK.
if node.travis_build_environment.user != "vagrant"
  link "/home/vagrant" do
    owner node.travis_build_environment.user
    group node.travis_build_environment.group

    to node.travis_build_environment.home
  end
end

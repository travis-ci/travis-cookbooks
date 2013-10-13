#
# Cookbook Name:: rvm
# Recipe:: multi
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

include_recipe "rvm"

# for JRuby and JRuby 1.6.x in 1.9 mode by default.
# For rvm::multi we assume it's OK to enforce JDK and assume JRuby will be
# provided. MK.
include_recipe "java"
include_recipe "maven" # JRuby head is now built with Maven
include_recipe "ant"   # Previous versions of JRuby are built with Ant


log "Using Ruby #{RUBY_VERSION}..."

default_ruby = node[:rvm][:default]
aliases      = node[:rvm][:aliases] || []
default_ruby_arguments = node.rvm.rubies.select{|rb| rb["name"] == default_ruby }.map{|rb| rb["arguments"] }.first

log "Default Ruby will be #{default_ruby}"

home = node.travis_build_environment.home
rvm  = "source #{home}/.rvm/scripts/rvm && rvm"
bin_rvm  = "#{home}/.rvm/bin/rvm"
env  = { 'HOME' => home, 'rvm_user_install_flag' => '1' }
user = node.travis_build_environment.user

setup = lambda do |bash|
  bash.user user
  bash.environment env
end

bash "update RVM to latest stable minor" do
  setup.call(self)
  code   "#{bin_rvm} get latest-minor"
end

# make sure default Ruby is installed first
bash "installing #{default_ruby} with RVM arguments #{default_ruby_arguments}" do
  setup.call(self)
  code   "#{bin_rvm} install #{default_ruby} --verify-downloads 1 -j 3 #{default_ruby_arguments} && #{rvm} alias create default #{default_ruby}"
  not_if "#{rvm} #{default_ruby} do echo 'Found'"
end

node.rvm.rubies.
  reject {|rb| rb[:name] == default_ruby}.each do |rb|
  bash "installing #{rb[:name]} with RVM arguments #{rb[:arguments]}" do
    setup.call(self)
    # another work around for https://github.com/rubinius/rubinius/pull/1759. MK.
    code "#{rvm} #{rb.fetch(:using, default_ruby)} do #{bin_rvm} install #{rb[:name]} --verify-downloads 1 -j 3 #{rb[:arguments]} && #{rvm} all do rvm --force gemset empty && find ~/.rvm/rubies/ -type d -name .git -print | xargs /bin/rm -rf"
    # with all the Rubies we provide, checking for various directories under .rvm/rubies/* is pretty much impossible without
    # depending on the exact versions provided. So we use this neat technique suggested by mpapis. MK.
    not_if "#{rvm} #{rb[:name]} do echo 'Found'"
  end
end

bash "update all rubies to the latest RubyGems" do
  setup.call(self)
  code   "#{bin_rvm} all --verbose do gem update --system"
end

aliases.each do |new_name, existing_name|
  bash "alias #{existing_name} => #{new_name}" do
    setup.call(self)
    code "#{rvm} alias create #{new_name} #{existing_name}"

    ignore_failure true # alias creation is not idempotent. MK.
  end
end

bash "clean up RVM sources, log files, etc" do
  setup.call(self)
  # gemset empty is needed only till https://github.com/rubinius/rubinius/pull/1759 gets fixed. @mpapis
  code "#{rvm} cleanup all && #{rvm} all do rvm --force gemset empty || true"
end

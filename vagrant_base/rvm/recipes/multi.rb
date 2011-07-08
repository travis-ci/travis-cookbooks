#
# Cookbook Name:: rvm
# Recipe:: multi
# Copyright 2011, Travis CI development team
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

gems    = node[:rvm].fetch(:gems, []) | ['bundler']
default = node[:rvm][:default] || node[:rvm][:rubies].first
aliases = node[:rvm][:aliases] || []

rvm  = "/home/vagrant/.rvm/bin/rvm"
user = "vagrant"
env  = { 'HOME' => "/home/vagrant", 'rvm_user_install_flag' => '1' }

setup = lambda do |target|
  target.environment env
  target.user user
end

node[:rvm][:rubies].each do |ruby|
  bash "installing #{ruby}" do
    setup.call(self)
    code   "#{rvm} install #{ruby}"
    not_if "#{rvm} && rvm list strings | grep #{ruby}"
  end

  gems.each do |gem|
    bash "installing gem #{gem} for #{ruby}" do
      setup.call(self)
      code   "#{rvm} use #{ruby} && gem install #{gem} --no-ri --no-rdoc"
      not_if "#{rvm} use #{ruby} && find $GEM_HOME/gems -name '#{gem}-[0-9]*.[0-9]*.[0-9]*'"
    end
  end
end

bash "make #{default} the default ruby" do
  setup.call(self)
  code "#{rvm} --default #{default}"
end

bash "install chef for the default Ruby" do
  setup.call(self)
  code   "#{rvm} use #{default} && gem install chef --no-ri --no-rdoc"
  not_if "#{rvm} use #{default} && find $GEM_HOME/gems -name 'chef-[0-9]*.[0-9]*.[0-9]*'"
end

aliases.each do |existing_name, new_name|
  bash "alias #{existing_name} => #{new_name}" do
    setup.call(self)
    code "#{rvm} alias create #{new_name} #{existing_name}"
    ignore_failure true # alias creation is not idempotent. MK.
  end
end

bash "clean up RVM sources, log files, etc" do
  setup.call(self)
  environment env
  user user
  code "#{rvm} cleanup all"
end

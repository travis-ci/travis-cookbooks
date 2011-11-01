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

gems    = node[:rvm].fetch(:gems, []) | ['bundler', 'rake']
aliases = node[:rvm][:aliases] || []

home = node[:rvm][:home]
rvm  = "source #{home}/.rvm/scripts/rvm && rvm"
env  = { 'HOME' => home, 'rvm_user_install_flag' => '1' }
user = node[:rvm][:user]

setup = lambda do |bash|
  bash.user user
  bash.environment env
end


# PLEASE READ THIS FIRST!
# PLEASE READ THIS FIRST!
# PLEASE READ THIS FIRST!
#
# Here is what's going on here: we need to install Rubies in a pretty specific order
# because Rubinius needs to be built with 1.8.7 (yes, it won't build itself. Why? I have no idea),
# but if we pass Rubies hash via node attributes, WE CANNOT GUARANTEE THE ORDER OF INSTALLATION,
# which means sometimes Rubinius will fail to install.
# Also, if installed on Ruby 1.9, Rubinius will pick up 1.9 mode as the default which is not what people
# typically want.
#
# So we HARDCODE INSTALLATION ORDER here: our RVM cookbook is not for general use and nobody installs a dozen
# of various rubies on their servers anyway. This is the only way to make it work and for me to not lose sanity
# over this Ruby versions zoo. MK.
#
#
# First, install 1.8.7 and make it the default.
#
bash "installing 1.8.7" do
  setup.call(self)
  code   "#{rvm} install 1.8.7"
  not_if "ls #{home}/.rvm/rubies | grep 1.8.7"
end
bash "make 1.8.7 the default ruby" do
  setup.call(self)
  code "#{rvm} --default 1.8.7"
end
bash "install chef for the default Ruby" do
  setup.call(self)
  code   "#{rvm} use 1.8.7 && gem install chef --no-ri --no-rdoc"
  not_if "bash -c '#{rvm} use 1.8.7 && find $GEM_HOME/gems -name \"chef-[0-9]*.[0-9]*.[0-9]*\" | grep chef'", :environment => env
end

# then install JRuby in 1.8 mode
bash "installing JRuby in 1.8 mode" do
  setup.call(self)
  code   "#{rvm} install jruby"
  not_if "ls #{home}/.rvm/rubies | grep jruby"
end

# then install Rubinius in 1.8 mode using 2.0.testing
# the Rubinius team keeps stable for Travis.
bash "installing Rubinius in 1.8 mode (from 2.0.testing branch)" do
  setup.call(self)
  code   "#{rvm} install rbx-head --branch 2.0.testing"
  not_if "ls #{home}/.rvm/rubies | grep rbx-head"
end

# then install REE
bash "installing REE" do
  setup.call(self)
  code   "#{rvm} install ree"
  not_if "ls #{home}/.rvm/rubies | grep ree"
end

# then install 1.9.2
bash "installing 1.9.2" do
  setup.call(self)
  code   "#{rvm} install 1.9.2"
  not_if "ls #{home}/.rvm/rubies | grep 1.9.2"
end

# then install 1.9.3
bash "installing 1.9.3" do
  setup.call(self)
  code   "#{rvm} install 1.9.3"
  not_if "ls #{home}/.rvm/rubies | grep 1.9.3"
end

# then install Rubinius with 1.9 mode by default using 1.9.3
bash "installing Rubinius in 1.9 mode by default using Ruby 1.9.3" do
  setup.call(self)
  code   "#{rvm} use 1.9.3 && #{rvm} install rbx-head -n d19 --branch 2.0.testing -- --default-version=1.9"
  not_if "ls #{home}/.rvm/rubies | grep rbx-head-d19"
end


# then install ruby-head
bash "installing ruby-head" do
  setup.call(self)
  code   "#{rvm} install ruby-head"
  not_if "ls #{home}/.rvm/rubies | grep ruby-head"
end

# then install 1.8.6 (just for Sinatra, DO NOT ADD IT TO THE DOCUMENTATION or mention it anywhere. It is a pain to
# maintain and must go away). MK.
bash "installing 1.8.6" do
  setup.call(self)
  code   "#{rvm} install 1.8.6"
  not_if "ls #{home}/.rvm/rubies | grep 1.8.6"
end



# now we can install gems by iterating over rubies in any order. MK.
%w(1.8.7 jruby rbx ree 1.9.2 1.9.3 ruby-head).each do |name|
  gems.each do |gem|
    bash "installing gem #{gem} for #{name}" do
      setup.call(self)
      code   "#{rvm} use #{name}; gem install #{gem} --no-ri --no-rdoc"
    end
  end
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
  code "#{rvm} cleanup all"
end

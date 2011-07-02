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

default_ruby = node[:rvm][:default_ruby] || node[:rvm][:rubies].first

source_rvm   = "source \"$HOME/.rvm/scripts/rvm\""
rvm_command  = "#{source_rvm} && rvm"
gem_command  = "#{source_rvm} && gem"

rvm_user     = "vagrant"

node[:rvm][:rubies].each do |ruby_version|
  bash "installing #{ruby_version}" do
    user rvm_user
    code "#{rvm_command} install #{ruby_version} && #{rvm_command} use #{ruby_version} && gem install bundler #{(node[:rvm][:default_gems]).join(' ')} --no-ri --no-rdoc"
    not_if "which rvm && rvm list | grep #{ruby_version}"
  end

  gems = node[:rvm].fetch(:default_gems, []) | ['bundler']
  gems.each do |name|
    bash "installing gem #{name} for #{ruby_version}" do
      user rvm_user
      code   "#{rvm_command} && rvm use #{ruby_version} && gem install #{name} --no-ri --no-rdoc"
      not_if "#{rvm_command} && rvm use #{ruby_version} && gem  list | grep #{name}"
    end
  end

  if ruby_version == default_ruby
    bash "make #{default_ruby} the default ruby" do
      user rvm_user
      code "#{rvm_command} --default #{default_ruby}"
    end

    bash "install chef for the default Ruby" do
      user rvm_user
      code "#{rvm_command} use #{default_ruby} && gem install chef --no-ri --no-rdoc"
      not_if "which gem && gem list | grep chef"
    end
  end
end


node[:rvm][:aliases].each do |existing_name, new_name|
  bash "alias #{existing_name} => #{new_name}" do
    user rvm_user
    code "#{rvm_command} alias create #{new_name} #{existing_name}"

    # alias creation is not idempotent. MK.
    ignore_failure true
  end
end

bash "clean up RVM sources, log files, etc" do
  user rvm_user
  code "#{rvm_command} cleanup all"
end

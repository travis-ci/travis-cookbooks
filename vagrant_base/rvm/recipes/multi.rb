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
rvm_command  = "source \"$HOME/.rvm/scripts/rvm\" && rvm"

rvm_user     = "vagrant"

node[:rvm][:rubies].each do |ruby_version|
  bash "installing #{ruby_version}" do
    user rvm_user
    code "#{rvm_command} install #{ruby_version} && rvm use #{ruby_version} && gem install bundler #{(node[:rvm][:default_gems]).join(' ')} --no-ri --no-rdoc"
    not_if "which rvm && rvm list | grep #{ruby_version}"
  end

  if ruby_version == default_ruby
    bash "make #{default_ruby} the default ruby" do
      user rvm_user
      code "#{rvm_command} --default #{default_ruby} && rvm use #{ruby_version} && gem install chef --no-ri --no-rdoc"
    end
  end
end


node[:rvm][:aliases].each do |existing_name, new_name|
  bash "alais #{existing_name} => #{new_name}" do
    user rvm_user
    code "#{rvm_command} alias create #{new_name} #{existing_name}"

    # alias creation is not idempotent. MK.
    ignore_failure true
  end
end

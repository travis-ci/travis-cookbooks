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

default_ruby = node[:rvm][:default] || node[:rvm][:rubies].first

source_rvm   = "source \"/home/vagrant/.rvm/scripts/rvm\""
rvm_command  = "#{source_rvm} && rvm"
gem_command  = "#{source_rvm} && gem"

rvm_user     = "vagrant"

node[:rvm][:rubies].each do |ruby|
  bash "installing #{ruby}" do
    user        rvm_user
    environment Hash['HOME' => "/home/vagrant", 'rvm_user_install_flag' => '1']
    code        "#{rvm_command} install #{ruby} && #{rvm_command} use #{ruby} && gem install bundler #{(node[:rvm][:default_gems]).join(' ')} --no-ri --no-rdoc"
    not_if      "which rvm && rvm list | grep #{ruby}"
  end

  gems = node[:rvm].fetch(:gems, []) | ['bundler']
  gems.each do |gem|
    bash "installing gem #{gem} for #{ruby}" do
      user        rvm_user
      environment Hash['HOME' => "/home/vagrant", 'rvm_user_install_flag' => '1']
      code        "#{rvm_command} && rvm use #{ruby} && gem install #{gem} --no-ri --no-rdoc"
      not_if      "find ~/.rvm/gems/#{ruby}/gems -name '#{gem}-[0-9].[0-9].[0-9]'"
    end
  end
end

bash "make #{default_ruby} the default ruby" do
  user rvm_user
  code "#{rvm_command} --default #{default_ruby}"
end

bash "install chef for the default Ruby" do
  user   rvm_user
  code   "#{rvm_command} use #{default_ruby} && gem install chef --no-ri --no-rdoc"
  not_if "find ~/.rvm/gems/#{default_ruby}/gems -name 'chef-[0-9].[0-9].[0-9]'"
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

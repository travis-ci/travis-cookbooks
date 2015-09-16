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

include_recipe "java"
include_recipe "ant"

gems = (node[:rvm][:gems] || ['bundler', 'rake'])
rvm  = "source /usr/local/rvm/scripts/rvm && rvm"

node[:rvm][:rubies].each do |ruby|
  bash "Installing #{ruby[:name]} with RVM arguments #{ruby[:arguments]}" do
    code "#{rvm} install #{ruby[:name]} #{ruby[:arguments]}"
    not_if "#{rvm} list | grep #{ruby[:check_for] || ruby[:name]}"
  end

  name = ruby[:check_for] || ruby[:name]
  gems.each do |gem|
    bash "installing gem #{gem} for #{name}" do
      code "#{rvm} use #{name}; gem install #{gem} --no-ri --no-rdoc"
    end
  end
end

bash "clean up RVM sources, log files, etc" do
  code "#{rvm} cleanup all"
end

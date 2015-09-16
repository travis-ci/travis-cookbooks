#
# Cookbook Name:: users
# Recipe:: default
#
# Copyright 2015, Travis CI GmbH
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

package 'zsh' do
  action :upgrade
  only_if { node['users'].any? { |u| u['shell'] == '/bin/zsh' } }
end

Array(node['users']).each do |user|
  user user['id'] do
    supports manage_home: true
    home "/home/#{user['id']}"
    shell user['shell']
  end

  %W(
    /home/#{user['id']}
    /home/#{user['id']}/.ssh
  ).each do |dirname|
    directory dirname do
      owner user['id']
      group user['id']
      mode 0700
    end
  end

  template "/home/#{user['id']}/.ssh/authorized_keys" do
    owner user['id']
    group user['id']
    mode 0644
    source 'authorized_keys.erb'
    variables(keys: user['ssh_keys'])
    not_if { Array(user['ssh_keys']).empty? }
  end

  users_github_keys user['id'] do
    github_username user['github_username']

    only_if do
      Array(user['ssh_keys']).empty? && !user['github_username'].empty?
    end
  end
end

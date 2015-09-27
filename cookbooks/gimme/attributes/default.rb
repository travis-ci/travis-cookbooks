#
# Cookbook Name:: gimme
# Attributes:: default
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

default['gimme']['url'] = 'https://raw.githubusercontent.com/meatballhat/gimme/v0.2.3/gimme'
default['gimme']['sha256sum'] = '62673853c69cf0efc2ad33cf446dffad0807c0508eaa6cd7fd942384323f25e9'
default['gimme']['default_version'] = ''
default['gimme']['versions'] = %w()
default['gimme']['install_user'] = 'travis'
default['gimme']['install_user_home'] = '/home/travis'
default['gimme']['debug'] = false

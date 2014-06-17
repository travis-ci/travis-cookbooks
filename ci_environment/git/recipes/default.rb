#
# Cookbook Name:: git
# Recipe:: default
#
# Copyright 2011-2013, Travis CI Development Team <contact@travis-ci.org>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# 11.10 and 12.04 no longer use git-core and provide a recent version. So we
# can just use standard packages. MK.

# package "git" do
#   action :install
# end

# setting the default to the ppa recipe as it includes
# a much more recent version of git
include_recipe "git::ppa"
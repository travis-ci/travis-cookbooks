#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: python
# Attribute:: default
#
# Copyright 2011, Opscode, Inc.
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
#
default['python']['pyenv']['revision'] = "22f4218522de9125ead3a1b3d0e2917100c8f927"

# Order matters for this list of Pythons. It will be used to construct the
# $PATH so items earlier in the list will take precedence over items later in
# the list. This order means that ``python`` will be 2.7.6, ``python2`` will be
# 2.7.6, and ``python3`` will be 3.4.1.
default['python']['pyenv']['pythons'] = [
    "2.7.8",
    "2.6.9",
    "3.4.1",
    "3.3.5",
    "3.2.5",
    "pypy3-2.3.1",
    "pypy-2.3.1",
    "pypy-2.2.1",
]

default['python']['pyenv']['aliases'] = {
    "2.6.9" => ["2.6"],
    "2.7.8" => ["2.7"],
    "3.2.5" => ["3.2"],
    "3.3.5" => ["3.3"],
    "3.4.1" => ["3.4"],
    "pypy3-2.3.1" => ["pypy3"],
    "pypy-2.3.1" => ["pypy"],
}

default['python']['pip']['packages'] = {
    "default" => ["nose", "pytest", "mock"],
    "2.6" => ["numpy"],
    "2.7" => ["numpy"],
    "3.2" => ["numpy"],
    "3.3" => ["numpy"],
    "3.4" => ["numpy"],
}

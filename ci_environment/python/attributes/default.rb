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

default['python']['pyenv']['revision'] = "c452da8084a6236ce66411b7fc6036f8d38930dc"

# Order matters for this list of Pythons. It will be used to construct the
# $PATH so items earlier in the list will take precedence over items later in
# the list. This order means that ``python`` will be 2.7.12, ``python2`` will be
# 2.7.12, and ``python3`` will be 3.4.4
default['python']['pyenv']['pythons'] = [
    "2.7.12",
    "2.6.9",
    "3.5.2",
    "3.4.4",
    "3.3.6",
    "3.2.6",
    "pypy-5.3.1",
    "pypy3-2.4.0",
]

default['python']['pyenv']['aliases'] = {
    "2.6.9" => ["2.6"],
    "2.7.12" => ["2.7"],
    "3.2.6" => ["3.2"],
    "3.3.6" => ["3.3"],
    "3.4.4" => ["3.4"],
    "3.5.2" => ["3.5"],
    "pypy-5.3.1" => ["pypy"],
    "pypy3-2.4.0" => ["pypy3"],
}

default['python']['pip']['packages'] = {
    "default" => ["nose", "pytest", "mock", "wheel"],
    "2.6" => ["numpy"],
    "2.7" => ["numpy"],
    "3.2" => ["numpy"],
    "3.3" => ["numpy"],
    "3.4" => ["numpy"],
    "3.5" => ["numpy"],
}

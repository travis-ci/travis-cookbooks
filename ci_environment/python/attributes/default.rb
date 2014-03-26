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
default['python']['pyenv']['revision'] = "cf89abaacff804b7b2047e3ee2ff6df5651b1ce5"
default['python']['pyenv']['pythons'] = [
    "2.6.9",
    "2.7.6",
    "3.2.5",
    "3.3.5",
    "3.4.0",
    "pypy-2.2.1",
]
default['python']['pyenv']['aliases'] = {
    "2.6.9" => ["2.6"],
    "2.7.6" => ["2.7"],
    "3.2.5" => ["3.2"],
    "3.3.5" => ["3.3"],
    "3.4.0" => ["3.4"],
    "pypy-2.2.1" => ["pypy"],
}
default['python']['pip']['packages'] = {
    "default" => ["nose", "pytest", "mock"],
    "2.6" => ["numpy"],
    "2.7" => ["numpy"],
    "3.2" => ["numpy"],
    "3.3" => ["numpy"],
    "3.4" => ["numpy"],
}

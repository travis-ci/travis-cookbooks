#
# Cookbook Name:: zeromq
# Recipe:: 2.0.x
#
# Copyright 2011, Travis CI Development Team
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

apt_repository "zeromq PPA" do
  uri "http://ppa.launchpad.net/chris-lea/zeromq/ubuntu"
  distribution "natty"
  components ["main"]
  key "https://raw.github.com/gist/dc879e13ab46579f80bb/4b9afa5f31d34eaf29ae209f6c2b99891d9935f1/gistfile1.txt"
  action :add
end

package "libzmq-dev"
package "libzmq1"

# in case some test suites compile bindings like jzmq
# from source, for whatever reason. MK.
package "libtool"

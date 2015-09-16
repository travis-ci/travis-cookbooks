# Copyright 2012-2013, Travis CI Development Team <contact@travis-ci.org>
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

# https://launchpad.net/~couchdb/+archive/stable

apt_repository "couchdb-ppa" do
  uri          "http://ppa.launchpad.net/couchdb/stable/ubuntu"
  distribution node['lsb']['codename']
  components   ["main"]
  key          "C17EAB57"
  keyserver    "keyserver.ubuntu.com"

  action :add
end

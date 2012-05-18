#
# Copyright 2012, Erik Frèrejean - erikfrerejean@phpbb.com
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
maintainer        "Erik Frerejean"
maintainer_email  "erikfrerejean@phpbb.com"
license           "Apache 2.0"
description       "Installs firebird"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
recipe            "firebird", "Installs firebird"

%w{ubuntu debian}.each do |os|
  supports os
end


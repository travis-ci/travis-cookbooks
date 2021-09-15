#
# Cookbook:: openssl
# Library:: secure_password
# Author:: Joshua Timberman <joshua@chef.io>
#
# Copyright:: 2009, Chef Software, Inc.
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

include OpenSSLCookbook::Helpers

module Opscode
  module OpenSSL
    # Generate secure passwords with OpenSSL
    module Password
      def secure_password(length = 20)
        pw = ''

        pw << ::OpenSSL::Random.random_bytes(1).gsub(/\W/, '') while pw.length < length

        pw
      end
    end
  end
end

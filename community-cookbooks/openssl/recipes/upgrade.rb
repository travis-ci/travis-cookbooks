#
# Cookbook:: openssl
# Recipe:: upgrade
#
# Copyright:: 2015, Chef Software, Inc. <legal@chef.io>
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
include_recipe 'chef-sugar'

# Attributes are set here and not in attributes/default.rb because of the
# chef-sugar dependency for the methods evaluated in the case statement.
node.default['openssl']['packages'] = if debian_before_or_at_squeeze? || ubuntu_before_or_at_lucid?
                                        %w(libssl0.9.8 openssl)
                                      elsif debian_after_or_at_wheezy? || ubuntu_after_or_at_precise?
                                        %w(libssl1.0.0 openssl)
                                      elsif rhel?
                                        %w(openssl)
                                      else
                                        []
                                      end

node['openssl']['packages'].each do |ssl_pkg|
  package ssl_pkg do
    action :upgrade
    node['openssl']['restart_services'].each do |ssl_svc|
      notifies :restart, "service[#{ssl_svc}]"
    end
  end
end

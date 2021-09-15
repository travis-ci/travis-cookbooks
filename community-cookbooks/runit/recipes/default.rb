#
# Cookbook:: runit
# Recipe:: default
#
# Copyright:: 2008-2010, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

service 'runit' do
  action :nothing
end

execute 'start-runsvdir' do
  command value_for_platform(
    'debian' => { 'default' => 'runsvdir-start' },
    'ubuntu' => { 'default' => 'start runsvdir' },
    'gentoo' => { 'default' => '/etc/init.d/runit-start start' }
  )
  action :nothing
end

execute 'runit-hup-init' do
  command 'telinit q'
  only_if 'grep ^SV /etc/inittab'
  action :nothing
end

case node['platform_family']
when 'rhel', 'fedora'

  packagecloud_repo 'imeyer/runit' unless node['runit']['prefer_local_yum']
  package 'runit'

  if node['platform_version'].to_i == 7
    service 'runsvdir-start' do
      action [:start, :enable]
    end
  end

when 'debian', 'gentoo'

  if platform?('gentoo')
    template '/etc/init.d/runit-start' do
      source 'runit-start.sh.erb'
      mode '755'
    end

    service 'runit-start' do
      action :nothing
    end
  end

  package 'runit' do
    action :install
    response_file 'runit.seed' if platform?('ubuntu', 'debian')
    notifies value_for_platform(
      'debian' => { '4.0' => :run, 'default' => :nothing },
      'ubuntu' => {
        'default' => :nothing,
        '9.04' => :run,
        '8.10' => :run,
        '8.04' => :run },
      'gentoo' => { 'default' => :run }
    ), 'execute[start-runsvdir]', :immediately
    notifies value_for_platform(
      'debian' => { 'squeeze/sid' => :run, 'default' => :nothing },
      'default' => :nothing
    ), 'execute[runit-hup-init]', :immediately
    notifies :enable, 'service[runit-start]' if platform?('gentoo')
  end

  if node['platform'] =~ /ubuntu/i && node['platform_version'].to_f <= 8.04
    cookbook_file '/etc/event.d/runsvdir' do
      source 'runsvdir'
      mode '644'
      notifies :run, 'execute[start-runsvdir]', :immediately
      only_if { ::File.directory?('/etc/event.d') }
    end
  end
end

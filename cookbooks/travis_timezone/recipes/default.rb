#
# Cookbook Name:: travis_timezone
# Recipe:: default
#
# Copyright 2010, James Harton <james@sociable.co.nz>
# Copyright 2015, Travis CI GmbH
#
# Apache 2.0 License.
#

if %w(debian ubuntu).member? node['platform']
  package 'tzdata'

  bash 'dpkg-reconfigure tzdata' do
    user 'root'
    code '/usr/sbin/dpkg-reconfigure -f noninteractive tzdata'
    action :nothing
  end

  template '/etc/timezone' do
    source 'timezone.conf.erb'
    owner 'root'
    group 'root'
    mode 0644
    notifies :run, 'bash[dpkg-reconfigure tzdata]'
  end
end

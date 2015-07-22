#
# Cookbook Name:: timezone
# Recipe:: default
#
# Copyright 2010, James Harton <james@sociable.co.nz>
#
# Apache 2.0 License.
#


case node.platform
when ['debian','ubuntu']
  package "tzdata" do
    version "2012b-1"
    options "--force-yes"
    only_if { node['lsb']['codename'] == 'precise' }
  end

  package "tzdata" do
    not_if { node['lsb']['codename'] == 'precise' }
  end

  template "/etc/timezone" do
    source "timezone.conf.erb"
    owner 'root'
    group 'root'
    mode 0644
    notifies :run, 'bash[dpkg-reconfigure tzdata]'
  end

  bash 'dpkg-reconfigure tzdata' do
    user 'root'
    code "/usr/sbin/dpkg-reconfigure -f noninteractive tzdata"
    action :nothing
  end
end

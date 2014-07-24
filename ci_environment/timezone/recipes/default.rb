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
  # Make sure it's installed. It would be a pretty broken system
  # that didn't have it.
  platform_version = node.platform_version.to_f
  if platform_version >= 12.04 && platform_version < 14.04
    package "tzdata" do
      version "2012b-1"
      options "--force-yes"
    end
  else
    package "tzdata"
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

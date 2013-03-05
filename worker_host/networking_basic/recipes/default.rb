#
# Cookbook Name:: debian_basic
# Recipe:: default
#
# Copyright 2010, fredz
#
# All rights reserved - Do Not Redistribute
#

packages = [
  'lsof',
  'iptables',
  'curl',
  'wget',
  'rsync',
  'nmap',
  'ethtool',
  'iproute',
  'iputils-ping',
  'netcat-openbsd',
  'tcpdump',
  'bind9-host'
]

case node[:platform]
  when "debian", "ubuntu"
    packages.each do |pkg|
      package pkg do
        action :install
    end
  end
end

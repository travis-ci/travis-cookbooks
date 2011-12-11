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
  'whois',
  'curl',
  'wget',
  'rsync',
  'traceroute',
  'iproute',
  'iputils-ping',
  "libcurl4-openssl-dev"
]

case node[:platform]
  when "debian", "ubuntu"
    packages.each do |pkg|
      package pkg do
        action :install
    end
  end
end

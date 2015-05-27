default['clang']['version']       = '3.5.0'

default['clang']['download_url']  = "http://llvm.org/releases/#{node['clang']['version']}/clang+llvm-#{node['clang']['version']}-x86_64-linux-gnu-ubuntu-14.04.tar.xz"
default['clang']['extension']     = 'tar.xz'
default['clang']['checksum']      = 'b9b420b93d7681bb2b809c3271ebdf4389c9b7ca35a781c7189d07d483d8f201'

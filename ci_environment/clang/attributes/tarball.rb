default['clang']['version']       = '3.4.2'

default['clang']['download_url']  = "http://llvm.org/releases/#{node['clang']['version']}/clang+llvm-#{node['clang']['version']}-x86_64-linux-gnu-ubuntu-14.04.xz"
default['clang']['extension']     = 'tar.xz'
default['clang']['checksum']      = 'ef0d8faeb31c731b46ef5859855766ec7eb71f9a32cc6407ac5ddb4ccc35c3dc'

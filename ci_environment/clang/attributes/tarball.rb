default['clang']['version']       = '3.2'

default['clang']['download_url']  = "http://llvm.org/releases/#{node['clang']['version']}/clang+llvm-#{node['clang']['version']}-x86_64-linux-ubuntu-12.04.tar.gz"
default['clang']['checksum']      = '5b5a23eef95d88eecf4e2009b9afd17675a5455735fd6e1315a75d7b6543b347'

# upcoming switch to clang 3.3...
# default['clang']['download_url']  = "http://llvm.org/releases/#{node['clang']['version']}/clang+llvm-#{node['clang']['version']}-amd64-Ubuntu-12.04.2.tar.gz"
# default['clang']['checksum']      = '60d8f69f032d62ef61bf527857ebb933741ec3352d4d328c5516aa520662dab7'

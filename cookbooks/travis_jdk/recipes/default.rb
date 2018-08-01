# Cookbook:: travis_jdk
# Recipe:: default
#
# The MIT License (MIT)
#
# Copyright:: 2018, Travis CI GmbH
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

def install_jdk_args(jdk)
  m = jdk.match(/(?<vendor>[a-z]+)-?(?<version>.+)?/)
  if m[:vendor].start_with? 'oracle'
    license = 'BCL'
  elsif m[:vendor].start_with? 'openjdk'
    license = 'GPL'
  else
    puts 'Houston is calling'
  end
  puts "jdk: #{jdk}, vendor: #{m[:vendor]}, version: #{m[:version]}, license: #{license}"
  "--feature #{m[:version]} --license #{license}"
end

config = node['travis_jdk']

config['versions'] << config['default'] unless config['versions'].include?(config['default'])

puts "Destination path: #{node['travis_jdk']['install_jdk_path']}"
remote_file 'install-jdk.sh' do
  source 'https://raw.githubusercontent.com/sormuras/bach/master/install-jdk.sh'
  path config['install-jdk.sh_path']
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  sensitive true
end

config['versions'].each do |jdk|
  args = install_jdk_args jdk
  cache = "#{Chef::Config[:file_cache_path]}/#{jdk}"
  target = "/usr/lib/jvm/#{jdk}"

  bash "Install #{jdk}" do
    code "#{config['install-jdk.sh_path']} #{args} --target #{target} --workspace #{cache}"
  end
end

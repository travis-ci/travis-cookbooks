require 'tmpdir'

java_home = node['java']["java_home"]
arch = node['java']['arch']
jdk_version = node['java']['jdk_version']

#convert version number to a string if it isn't already
if jdk_version.instance_of? Fixnum
  jdk_version = jdk_version.to_s
end

case jdk_version
when "6"
  tarball_url = node['java']['jdk']['6']['windows'][arch]['url']
  #tarball_checksum = node['java']['jdk']['6']['windows'][arch]['checksum']
when "7"
  tarball_url = node['java']['jdk']['7']['windows'][arch]['url']
  #tarball_checksum = node['java']['jdk']['7']['windows'][arch]['checksum']
end

if tarball_url =~ /example.com/
  Chef::Application.fatal!("You must change the download link to your private repository. You can no longer download java directly from http://download.oracle.com without a web broswer")
end

dir = Dir.tmpdir()

if !ENV["PATH"].include? "%JAVA_HOME%"
env "PATH" do
    value ENV["PATH"]+";%JAVA_HOME%\\bin"
end
ENV["PATH"]+=";C:\\Program Files\\Java\\jre7\\bin"
end

env "JAVA_HOME" do
    value "C:\\Program Files\\Java\\jre7"
end
ENV["JAVA_HOME"] = "C:\\Program Files\\Java\\jre7"

node[:java][:jdk_dir] = nil #space in path will mess up most recipes

execute "jre" do
    command "#{dir}/jre.exe /s /L C:/java-setup.log"
    action :nothing
end

remote_file "#{dir}/jre.exe" do
    source tarball_url
    action :create_if_missing
    notifies :run, "execute[jre]", :immediately
end




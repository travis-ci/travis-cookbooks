include_recipe "mingw::default"

execute "install msys" do
  command "mingw-get install msys"
  not_if { File.exists?("#{node[:mingw][:dir]}\\msys\\1.0\\bin\\make.exe") }
end

execute "install wget" do
  command "mingw-get install msys-wget"
  not_if { File.exists?("#{node[:mingw][:dir]}\\msys\\1.0\\bin\\wget.exe") }
end

execute "install patch" do
  command "mingw-get install msys-patch"
  not_if { File.exists?("#{node[:mingw][:dir]}\\msys\\1.0\\bin\\patch.exe") }
end

execute "install tar" do
  command "mingw-get install msys-tar"
  command "mingw-get install msys-libbz2"
  not_if { File.exists?("#{node[:mingw][:dir]}\\msys\\1.0\\bin\\tar.exe") }
end

execute "install wget" do
  command "mingw-get install msys-perl"
  not_if { File.exists?("#{node[:mingw][:dir]}\\msys\\1.0\\bin\\perl.exe") }
end

execute "install m4" do
  command "mingw-get install msys-m4"
  not_if { File.exists?("#{node[:mingw][:dir]}\\msys\\1.0\\bin\\m4.exe") }
end

execute "install flex" do
  command "mingw-get install msys-flex"
  not_if { File.exists?("#{node[:mingw][:dir]}\\msys\\1.0\\bin\\flex.exe") }
end

execute "install perl" do
  command "mingw-get install msys-perl"
  not_if { File.exists?("#{node[:mingw][:dir]}\\msys\\1.0\\bin\\perl.exe") }
end

execute "install iconv" do
  command "mingw-get install mingw32-libiconv"
  not_if { File.exists?("#{node[:mingw][:dir]}\\bin\\iconv.exe") }
end

env "PATH" do
  action :modify
  delim File::PATH_SEPARATOR
  value "#{node[:mingw][:dir]}\\msys\\1.0\\bin"
end

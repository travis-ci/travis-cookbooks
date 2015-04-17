# Install PhantomJS 2.0.0 from custom-built archive

package 'libjpeg-dev'
package 'libpng-dev'
package 'libicu-dev'

archive_path = File.join(Chef::Config[:file_cache_path], 'phantomjs.tar.bz2')
version      = '2.0.0'
local_dir    = "/usr/local/phantomjs-#{version}/bin"

remote_file archive_path do
  source "https://s3.amazonaws.com/travis-phantomjs/phantomjs-#{version}-#{node.platform}-#{node.platform_version}.tar.bz2"
end

directory local_dir do
  user 'root'
  group 'root'
  recursive true
end

bash "expand phantomjs archive" do
  user 'root'
  group 'root'
  code "tar xjf #{archive_path} -C #{local_dir}"
  creates File.join(local_dir, 'phantomjs')
end
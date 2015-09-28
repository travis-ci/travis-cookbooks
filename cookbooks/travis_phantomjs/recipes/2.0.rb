# Install PhantomJS 2.0.0 from custom-built archive

package %w(
  libicu-dev
  libjpeg-dev
  libpng-dev
)

ark 'phantomjs' do
  url "https://s3.amazonaws.com/travis-phantomjs/phantomjs-2.0.0-#{node['platform']}-#{node['platform_version']}.tar.bz2"
  version '2.0.0'
  checksum '15052355c03b410b7e76ba51cdceebac5adc9f3ce872efc362b1b24a280f4240'
  has_binaries %w(phantomjs)
  owner 'root'
end

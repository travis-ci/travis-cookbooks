# Install PhantomJS 2.0.0 from custom-built archive

package %w(
  libicu-dev
  libjpeg-dev
  libpng-dev
)

ark 'phantomjs' do
  url ::File.join(
    'https://s3.amazonaws.com/travis-phantomjs',
    node['platform'],
    node['platform_version'],
    node['kernel']['machine'],
    'phantomjs-2.0.0.tar.bz2'
  )
  version '2.0.0'
  checksum '785913935b14dfadf759e6f54fc6858eadab3c15b87f88a720b0942058b5b573'
  has_binaries %w(phantomjs)
  owner 'root'
end

version = '1.9.8'
arch    = kernel['machine'] =~ /x86_64/ ? "x86_64" : "i686"

default[:phantomjs] = {
  :version => version,
  :arch    => arch,
  :tarball => {
    :url => ::File.join(
      'https://s3.amazonaws.com/travis-phantomjs/binaries',
      node['platform'],
      node['platform_version'],
      node['kernel']['machine'],
      "phantomjs-#{version}.tar.bz2"
  }
}

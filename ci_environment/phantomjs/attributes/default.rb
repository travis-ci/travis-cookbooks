version = "1.6.1"
arch    = arch = kernel['machine'] =~ /x86_64/ ? "amd64" : "i686"

default[:phantomjs] = {
  :version => version,
  :tarball => {
    :arch => arch,
    :url  => "http://phantomjs.googlecode.com/files/phantomjs-#{version}-linux-#{arch}-dynamic.tar.gz"
  }
}

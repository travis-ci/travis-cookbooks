version = "1.8.1"
arch    = kernel['machine'] =~ /x86_64/ ? "x86_64" : "i686"

default[:phantomjs] = {
  :version => version,
  :arch    => arch,
  :tarball => {
    :url  => "http://phantomjs.googlecode.com/files/phantomjs-#{version}-linux-#{arch}.tar.bz2"
  }
}

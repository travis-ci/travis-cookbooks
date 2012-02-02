version = "1.4.1"

default[:phantomjs] = {
  :version => version,
  :tarball => {
    :url => "http://phantomjs.googlecode.com/files/phantomjs-#{version}-linux-x86-dynamic.tar.gz"
  }
}

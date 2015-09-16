version = "1.9.8"
arch    = kernel['machine'] =~ /x86_64/ ? "x86_64" : "i686"

default[:phantomjs] = {
  :version => version,
  :arch    => arch,
  :tarball => {
    :url => "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-#{version}-linux-#{arch}.tar.bz2"
  }
}

version = "2.1"
arch = kernel['machine'] =~ /x86_64/ ? "amd64" : "i386"

default[:pypy] = {
  :tarball => {
    :version => version,
    :arch    => arch,
    :url     => if arch == "i386"
                  "https://bitbucket.org/pypy/pypy/downloads/pypy-#{version}-linux.tar.bz2"
                else
                  "https://bitbucket.org/pypy/pypy/downloads/pypy-#{version}-linux64.tar.bz2"
                end,
    :filename     => if arch == "i386"
                       "pypy-#{version}-linux.tar.bz2"
                     else
                       "pypy-#{version}-linux64.tar.bz2"
                     end,
    :dirname          => "pypy-#{version}",
    :installation_dir => "/usr/local/pypy"
  }
}

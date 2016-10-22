version = '5.4.1'
arch    = kernel['machine'] =~ /x86_64/ ? 'amd64' : 'i386'
linux_arch = arch == 'amd64' ? 'linux64' : 'linux'

default[:pypy] = {
  tarball: {
    version: version,
    arch: arch,
    url: "https://bitbucket.org/pypy/pypy/downloads/pypy2-v#{version}-#{linux_arch}.tar.bz2",
    filename: "pypy2-v#{version}-#{linux_arch}.tar.bz2",
    dirname: "pypy2-v#{version}-#{linux_arch}",
    installation_dir: '/usr/local/pypy'
  }
}

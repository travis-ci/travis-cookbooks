version = '1.9.8'
arch = kernel['machine'] =~ /x86_64/ ? 'x86_64' : 'i686'

default['travis_phantomjs']['version'] = version
default['travis_phantomjs']['arch'] = arch
default['travis_phantomjs']['tarball']['url'] = "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-#{version}-linux-#{arch}.tar.bz2"
default['travis_phantomjs']['tarball']['checksum'] = 'a1d9628118e270f26c4ddd1d7f3502a93b48ede334b8585d11c1c3ae7bc7163a'

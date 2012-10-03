arch = kernel['machine'] =~ /x86_64/ ? "amd64" : "i386"

default[:redis] = {
  :package => {
    :url => "http://files.travis-ci.org/packages/deb/redis/redis-server_2.4.16-1~dotdeb.0_#{arch}.deb"
  },
  :service => {
    :enabled => false
  }
}

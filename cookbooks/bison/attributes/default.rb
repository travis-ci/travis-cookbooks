arch     = kernel['machine'] =~ /x86_64/ ? "amd64" : "i386"
filename = "bison_2.4.1.dfsg-3_#{arch}.deb"

default[:bison] = {
  :filename => filename,
  :url      => "http://ftp.us.debian.org/debian/pool/main/b/bison/#{filename}"
}

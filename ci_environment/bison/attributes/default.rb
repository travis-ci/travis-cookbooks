arch     = kernel['machine'] =~ /x86_64/ ? "amd64" : "i386"
filename = "bison_3.0.4.dfsg-1+b1_#{arch}.deb"

default[:bison] = {
  :filename => filename,
  :url      => "http://ftp.us.debian.org/debian/pool/main/b/bison/#{filename}"
}

default[:mysql][:arch] = (kernel['machine'] =~ /x86_64/ ? "amd64" : "i386")

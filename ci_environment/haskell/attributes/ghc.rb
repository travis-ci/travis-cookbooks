default[:ghc] = {
  :version => "7.4.1",
  :arch    => kernel['machine'] =~ /x86_64/ ? "x86_64" : "i386"
}

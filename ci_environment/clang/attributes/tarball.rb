version = "3.2"

default[:clang] = {
  :version => version,
  :arch    => (kernel['machine'] =~ /x86_64/ ? "x86_64" : "x86")
}

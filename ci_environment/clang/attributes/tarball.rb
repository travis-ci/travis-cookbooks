version = "3.1"

default[:clang] = {
  :version => version,
  :arch    => case version
              when "3.1" then
                kernel['machine'] =~ /x86_64/ ? "x86_64" : "x86"
              else
                kernel['machine'] =~ /x86_64/ ? "x86_64" : "i386"
              end
}

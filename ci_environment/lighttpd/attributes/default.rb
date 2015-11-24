# rack uses lighttpd on port 9203 and no other project
# on travis-ci.org seems to use it, so make it the default. MK.
default[:lighttpd][:port] = 9203
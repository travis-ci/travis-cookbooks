@test "the server is configured" {
  test /etc/rsyslog.d/35-server-per-host.conf
}

@test "the remote.conf does not exist" {
  test ! -f /etc/rsyslog.d/remote.conf
}

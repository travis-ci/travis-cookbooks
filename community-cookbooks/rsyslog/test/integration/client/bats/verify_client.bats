@test "the config sets ActiveQueueMaxDiskSpace to 1G" {
  grep "^\$ActionQueueMaxDiskSpace 1G" /etc/rsyslog.d/49-remote.conf
}

@test "the config points to the remote server" {
  grep "@10.0.0.50:514" /etc/rsyslog.d/49-remote.conf
}

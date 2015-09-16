@test "rsyslog is up and running" {
  pgrep rsyslogd
}

# Ignore comments
# Ignore lines starting with $
# Ignore blank lines
# ensure facility is in proper format - x.x
@test "ensure default.conf is valid" {
  awk '$1 !~ /(^(#|\$|:)|^$|(.+\..+)+)/ { exit 1 }' /etc/rsyslog.d/50-default.conf
}

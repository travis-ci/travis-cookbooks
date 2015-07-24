@test "the input_file is created" {
  test /etc/rsyslog.d/99-test-file.conf
}

@test "the input_file contains given file" {
  grep "InputFileName /var/log/boot" /etc/rsyslog.d/99-test-file.conf
}

#!/usr/bin/env bats

@test "virgil1 user has rvm-1.19.6" {
  run sudo -u virgil1 -i rvm version
  [ $status -eq 0 ]
  [ "$(echo $output | awk '{print $2}')" = "1.19.6" ]
}

@test "virgil2 user has rvm-1.21.20" {
  run sudo -u virgil2 -i rvm version
  [ $status -eq 0 ]
  [ "$(echo $output | awk '{print $2}')" = "1.21.20" ]
}

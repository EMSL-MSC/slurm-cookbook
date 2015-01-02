#!/usr/bin/env bats

# check for our testing key
@test "munge_keycheck" {
  set +x
  check=$(md5sum /etc/munge/munge.key.base64 | awk '{ print $1 }')
  [ "$check" = "9a2fb3c27527b14509305c6ef5a6da23" ]
}

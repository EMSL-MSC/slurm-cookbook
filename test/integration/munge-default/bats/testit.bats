#!/usr/bin/env bats

@test "munge_credentials" {
  set +x
  munge -n > /tmp/munge-check
  status=$?
  [ "$status" -eq 0 ]
}
@test "munge_decrypt" {
  set +x
  unmunge < /tmp/munge-check
  status=$?
  [ "$status" -eq 0 ]
}
# check for our testing key
@test "munge_keycheck" {
  set +x
  check=$(md5sum /etc/munge/munge.key.base64 | awk '{ print $1 }')
  [ "$check" = "9a2fb3c27527b14509305c6ef5a6da23" ]
}

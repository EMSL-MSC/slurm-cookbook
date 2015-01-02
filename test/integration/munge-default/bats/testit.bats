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

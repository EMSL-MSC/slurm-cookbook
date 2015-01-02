#!/usr/bin/env bats

@test "munge_credentials" {
  munge -n > /tmp/munge-check
  status=$?
  [ "$status" -eq 0 ]
}
@test "munge_decrypt" {
  unmunge < /tmp/munge-check
  status=$?
  [ "$status" -eq 0 ]
}

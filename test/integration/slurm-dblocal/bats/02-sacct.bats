#!/usr/bin/env bats

@test "check_sacct" {
  run sacct
  [ "$status" -eq 0 ]
}

@test "check_sacctmgr" {
  run sacctmgr
  [ "$status" -eq 0 ]
}


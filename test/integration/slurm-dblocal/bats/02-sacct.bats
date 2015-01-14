#!/usr/bin/env bats

@test "check_sacct" {
  run sacct
  [ "$status" -eq 0 ]
}

@test "check_sacctmgr" {
  run sacctmgr list Cluster
  [ "$status" -eq 0 ]
}


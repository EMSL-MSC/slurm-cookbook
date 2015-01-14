#!/usr/bin/env bats

@test "sinfo_check" {
  run sinfo
  [ "$status" -eq 0 ]
}

@test "idle_node_check" {
  run scontrol update nodename=localhost state=idle
  [ "$status" -eq 0 ]
}

@test "srun_check" {
  run srun -n 1 echo hi
  [ "$status" -eq 0 ]
}

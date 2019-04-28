load '/opt/bats-support/load.bash'
load '/opt/bats-assert/load.bash'

@test "/usr/bin/entrypoint.sh returns 0" {
  run /bin/bash -c "dojo -c Dojofile.to_be_tested \"pwd && whoami\""
  # this is printed on test failure
  echo "output: $output"
  assert_output --partial "dojo init finished"
  assert_output --partial "openjdk-dojo"
  refute_output --partial "root"
  assert_equal "$status" 0
}

@test "ssh keys empty" {
  run /bin/bash -c "dojo -c Dojofile.to_be_tested \"test -f ~/.ssh/id_rsa\""
  assert_equal "$status" 1
}

load '/opt/bats-support/load.bash'
load '/opt/bats-assert/load.bash'

@test "git is installed" {
  run git --version
  assert_output --partial "git version"
  assert_equal "$status" 0
  run git status
  assert_output "fatal: Not a git repository (or any of the parent directories): .git"
}

load '/opt/bats-support/load.bash'
load '/opt/bats-assert/load.bash'

# all the ide scripts are set
@test "/usr/bin/entrypoint.sh exists and is a file" {
  run test -f /usr/bin/entrypoint.sh
  assert_equal "$status" 0
}
@test "/usr/bin/entrypoint.sh is owned by root" {
  run stat -c %U /usr/bin/entrypoint.sh
  assert_equal "$status" 0
  assert_equal "$output" "root"
}
@test "/usr/bin/entrypoint.sh is executable" {
  run test -x /usr/bin/entrypoint.sh
  assert_equal "$status" 0
}
@test "/etc/ide.d exists and is a directory" {
  run test -d /etc/ide.d
  assert_equal "$status" 0
}
@test "/etc/ide.d is owned by root" {
  run stat -c %U /etc/ide.d
  assert_equal "$status" 0
  assert_equal "$output" "root"
}
@test "/etc/ide.d/scripts exists and is a directory" {
  run test -d /etc/ide.d/scripts
  assert_equal "$status" 0
}
@test "/etc/ide.d/variables exists and is a directory" {
  run test -d /etc/ide.d/variables
  assert_equal "$status" 0
}
@test "/etc/ide.d/scripts/50-ide-fix-uid-gid.sh exists and is a file" {
  run test -f /etc/ide.d/scripts/50-ide-fix-uid-gid.sh
  assert_equal "$status" 0
}
@test "/etc/ide.d/scripts/50-ide-fix-uid-gid.sh is owned by root" {
  run stat -c %U /etc/ide.d/scripts/50-ide-fix-uid-gid.sh
  assert_equal "$status" 0
  assert_equal "$output" "root"
}
@test "/etc/ide.d/scripts/50-ide-fix-uid-gid.sh is executable" {
  run test -x /etc/ide.d/scripts/50-ide-fix-uid-gid.sh
  assert_equal "$status" 0
}

# All the ide scripts can be executed without error and many times.
# Do not run /etc/ide.d/scripts/* on their own here,
# because it needs variables which are sourced by /usr/bin/entrypoint.sh.
@test "/usr/bin/entrypoint.sh returns 0" {
  run /usr/bin/entrypoint.sh whoami 2>&1
  assert_equal "$status" 0
  # do not test which line returns those strings, sometimes there is
  # additional line: "usermod: no changes"
  assert_line --partial "ide init finished"
  assert_line --partial "using mono-ide:"
  assert_line "ide"
}

# This must run after entrypoint.sh, because at first 30-copy-ssh-configs.sh
# may be owned by some uid:gid which does not exist in current env (ideide)
# but exists on host (on go-agent) and that uid:gid is not 1000:1000.
# Custom configuration file
@test "/etc/ide.d/scripts/20-ide-setup-identity.sh exists and is a file" {
  run test -f /etc/ide.d/scripts/20-ide-setup-identity.sh
  assert_equal "$status" 0
}
@test "/etc/ide.d/scripts/20-ide-setup-identity.sh is executable" {
  run test -x /etc/ide.d/scripts/20-ide-setup-identity.sh
  assert_equal "$status" 0
}

# secret provided thanks to the custom configuration file
@test "/home/ide/.ssh/id_rsa exists and is a file" {
  run test -f /home/ide/.ssh/id_rsa
  assert_equal "$status" 0
}
@test "/home/ide/.ssh/id_rsa is owned by ide user" {
  run stat -c %U /home/ide/.ssh/id_rsa
  assert_equal "$status" 0
  assert_equal "$output" "ide"
}
@test "/home/ide/.gitconfig exists and is a file" {
  run test -f /home/ide/.gitconfig
  assert_equal "$status" 0
}

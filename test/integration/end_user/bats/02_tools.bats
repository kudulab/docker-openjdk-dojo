load '/opt/bats-support/load.bash'
load '/opt/bats-assert/load.bash'

@test "has java installed and it is invocable" {
  run /bin/bash -c "dojo -c Dojofile.to_be_tested \"java -version\""
  assert_output --partial 'openjdk version "1.8'
  assert_equal "$status" 0
}

@test "has correct environment variables set" {
  run /bin/bash -c "dojo -c Dojofile.to_be_tested \"env | grep JAVA\""
  assert_output --partial 'JAVA_HOME=/docker-java-home'
  assert_output --partial 'JAVA_VERSION=8u181'
  assert_output --partial 'JAVA_DEBIAN_VERSION=8u181-b13-1~deb9u1'
  assert_equal "$status" 0
}

@test "has gradle installed and it is invocable" {
  run /bin/bash -c "dojo -c Dojofile.to_be_tested \"gradle --version\""
  assert_output --partial 'Gradle 4.10'
  assert_equal "$status" 0
}

@test "has maven installed and it is invocable" {
  run /bin/bash -c "dojo -c Dojofile.to_be_tested \"mvn --version\""
  assert_output --partial 'Apache Maven 3.3.9'
  assert_equal "$status" 0
}

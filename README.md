# docker-java-ide

An IDE docker image with Java tools. Based on openjdk:8.

## Specification
This image has installed:
 * openjdk version "1.8"
 * OpenJDK Runtime Environment
 * Gradle 4.10
 * Apache Maven 3.3.9

## Usage
1. Install [IDE](https://github.com/ai-traders/ide)
2. Provide an Idefile:
```
IDE_DOCKER_IMAGE="docker-registry.ai-traders.com/java-ide:0.3.1_warm"
```
3. Run, example commands:
```bash
ide java -version
ide gradle --version
ide mvn --version
```

By default, current directory in docker container is `/ide/work`.


### Configuration
Those files are used inside the ide docker image:

1. `~/.ssh/config` -- will be generated on docker container start
2. `~/.ssh/id_rsa` -- it must exist locally, because it is a secret
 (but the whole `~/.ssh` will be copied)
2. `~/.gitconfig` -- if exists locally, will be copied
3. `~/.profile` -- will be generated on docker container start, in
   order to ensure current directory is `/ide/work`.

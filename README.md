# docker-java-ide

A Dojo docker image with Java tools. Based on openjdk:8.

## Specification
This image has installed:
 * openjdk version "1.8"
 * OpenJDK Runtime Environment
 * Gradle 4.10
 * Apache Maven 3.3.9

## Usage
1. Install [Dojo](https://github.com/ai-traders/dojo)
2. Provide an Dojofile:
```
# if you need k8s access configuration in ~/.kube, then export name of the k8s user in AIT_GPD_K8S_USER
export AIT_GPD_K8S_USER=gpd-testing
DOJO_DOCKER_IMAGE="docker-registry.ai-traders.com/java-ide:0.5.0"
```
3. Run, example commands:
```bash
dojo java -version
dojo gradle --version
dojo mvn --version
```

By default, current directory in docker container is `/dojo/work`.


### Configuration
Those files are used:

1. `~/.ssh/config` -- will be generated on docker container start
2. `~/.ssh/id_rsa` -- it must exist locally, because it is a secret
 (but the whole `~/.ssh` will be copied)
2. `~/.gitconfig` -- if exists locally, will be copied
3. `~/.profile` -- will be generated on docker container start, in
   order to ensure current directory is `/dojo/work`.

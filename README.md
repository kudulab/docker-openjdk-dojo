# docker-openjdk-dojo

A [Dojo](https://github.com/ai-traders/dojo) docker image with Java build tools. Based on openjdk:8.

## Specification
This image has installed:
 * openjdk version "1.8"
 * OpenJDK Runtime Environment
 * Gradle 4.10
 * Apache Maven 3.3.9

## Usage
1. Install [Dojo](https://github.com/ai-traders/dojo)
```bash
DOJO_VERSION=0.4.0
wget -O dojo https://github.com/ai-traders/dojo/releases/download/${DOJO_VERSION}/dojo_linux_amd64
sudo mv dojo /usr/local/bin
sudo chmod +x /usr/local/bin/dojo
```
2. Provide a Dojofile:
```
DOJO_DOCKER_IMAGE="kudulab/openjdk-dojo:1.0.0"
```
3. Run, example commands:
```bash
dojo java -version
dojo gradle --version
dojo mvn --version
```

By default, current directory in docker container is `/dojo/work`.

For a real-world usage see these projects:
 * [gocd-yaml-config-plugin](https://github.com/tomzo/gocd-yaml-config-plugin)
 * [gocd-json-config-plugin](https://github.com/tomzo/gocd-json-config-plugin)

### Configuration

These files are used inside the docker image:

1. `~/.ssh/` -- is copied from host to dojo's home `~/.ssh`
1. `~/.ssh/config` -- will be generated on docker container start. SSH client is configured to ignore known ssh hosts.
2. `~/.gitconfig` -- if exists locally, will be copied
3. `~/.profile` -- will be generated on docker container start, in
  order to ensure current directory is `/dojo/work`.

## License

Copyright 2019 Ewa Czechowska, Tomasz Sętkowski

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

#!/bin/bash

# those are set by a base image, but when using dojo, user may have overwritten
# them, so set them again:
export JAVA_HOME=/usr/local/openjdk-8
export JAVA_VERSION=8u212-b04
export JAVA_BASE_URL=https://github.com/AdoptOpenJDK/openjdk8-upstream-binaries/releases/download/jdk8u212-b04/OpenJDK8U-
export JAVA_URL_VERSION=8u212b04
export PATH=$JAVA_HOME/bin:$PATH

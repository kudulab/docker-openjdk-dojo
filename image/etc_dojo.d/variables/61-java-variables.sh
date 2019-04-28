#!/bin/bash

# those are set by a base image, but when using dojo, user may have overwritten
# them, so set them again:
export JAVA_HOME=/docker-java-home
export JAVA_VERSION=8u212
export JAVA_DEBIAN_VERSION=8u212-b01-1~deb9u1

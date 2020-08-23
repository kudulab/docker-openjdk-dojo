#!/bin/bash

# those are set by a base image, but when using dojo, user may have overwritten
# them, so set them again:
export JAVA_HOME=/usr/local/openjdk-14
export JAVA_VERSION=14.0.2
export PATH=$JAVA_HOME/bin:$PATH

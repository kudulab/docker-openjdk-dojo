#!/bin/bash -e

if [ -n "${AIT_GPD_K8S_USER}" ];  then
  sudo -E -H -u dojo /usr/bin/setup-kube "${AIT_GPD_K8S_USER}"
fi

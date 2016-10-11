#!/bin/bash

# This script is expected to be run in the ide docker image as ide
# linux user with all needed configs and secrets mounted.

git_repos=( "git@gitlab.ai-traders.com:gpd/api-gpd-server.git" )

original_dir=$(pwd)

for git_repo in "${git_repos[@]}"; do
  # split the git endpoint to get e.g. api-gpd-server
  dir_name=$(echo "${git_repo}" | cut -d'/' -f2 | cut -d'.' -f1)
  if [[ "${dir_name}" == "" ]]; then
    echo "Fail! dir_name variable was empty. Made up from: ${git_repo}"
    exit 1
  fi
  git clone "${git_repo}" "${dir_name}"
  if [[ "${dir_name}" == "api-gpd-server" ]]; then
    cd "${dir_name}/jaxrs-server"
  else
    cd "${dir_name}"
  fi
  # this writes into directory: ~/.gradle
  gradle downloadDependencies
  cd "${original_dir}"
  sudo rm -r "${dir_name}"
  echo "warmed up using ${git_repo}"
done

# remove secrets after warmup
rm -rf /home/ide/.ssh/*
rm -rf /home/ide/.gitconfig

exit 0

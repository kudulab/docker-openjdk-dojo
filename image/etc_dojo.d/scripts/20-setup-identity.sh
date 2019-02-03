#!/bin/bash -e

###########################################################################
# This file ensures files are mapped from dojo_identity into dojo_home.
# Fails if any required secret or configuration file is missing.
###########################################################################

# obligatory directory, copy it with all the secrets, particulary id_rsa
if [ ! -d "${dojo_identity}/.ssh" ]; then
  echo "${dojo_identity}/.ssh does not exist"
  exit 1;
fi
if [ ! -f "${dojo_identity}/.ssh/id_rsa" ]; then
  echo "${dojo_identity}/.ssh/id_rsa does not exist"
  exit 1;
fi
if [ ! -f "${dojo_identity}/.vault-token" ]; then
  echo "${dojo_identity}/.vault-token does not exist. You won't be able to access vault."
else
  cp ${dojo_identity}/.vault-token ${dojo_home}/.vault-token
  chown dojo:dojo ${dojo_home}/.vault-token
  chmod 0600 ${dojo_home}/.vault-token
fi
cp -r "${dojo_identity}/.ssh" "${dojo_home}"
for id_rsa_file in "${dojo_home}/.ssh/"*"id_rsa"; do
  chown dojo:dojo "${id_rsa_file}"
  chmod 0600 "${id_rsa_file}"
done

# we need to ensure that ${dojo_home}/.ssh/config contains at least:
# StrictHostKeyChecking no
echo "StrictHostKeyChecking no
UserKnownHostsFile /dev/null

ForwardAgent yes
Host git.ai-traders.com
User git
Port 2222
IdentityFile ${dojo_home}/.ssh/id_rsa

Host gogs.ai-traders.com
User git
Port 2222
IdentityFile ${dojo_home}/.ssh/id_rsa
" > "${dojo_home}/.ssh/config"

# not obligatory configuration file
if [ -f "${dojo_identity}/.gitconfig" ]; then
  cp "${dojo_identity}/.gitconfig" "${dojo_home}"
fi

# Not obligatory file; in order to ensure that after bash login, the dojo user
# is in /dojo/work. Not obligatory but shortens end user's commands.
# Do not copy it from $dojo_identity, because it may reference sth not installed in
# this docker image.
touch "${dojo_home}/.profile"
echo "cd ${dojo_work}" > "${dojo_home}/.profile"

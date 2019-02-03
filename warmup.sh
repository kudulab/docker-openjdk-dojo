#!/bin/bash -e

# This script is expected to be run outside dojo docker image, because
# it will invoke dojo command-line.
# Invoke this after dojo docker image was published with pretty tag like 0.1.0.

docker_image_name="$1"
if [ -z "$docker_image_name" ]; then
  echo "docker_image_name not set, fail"
  echo "example: docker-registry.ai-traders.com/some-ide"
  exit 1
fi

# get last git tag of this repository, e.g. '0.1.0'
last_git_tag=$(git describe --tags $(git rev-list --tags --max-count=1))
docker_tag="${docker_image_name}:${last_git_tag}_warm"
docker_tag_latest="${docker_image_name}:latest_warm"
base_image="${docker_image_name}:${last_git_tag}"
warmup_dir="$(pwd)/warmup"
if [ ! -d "$warmup_dir" ]; then
  echo "warmup_dir: ${warmup_dir} does not exist"
  exit 1
fi
dojofile="${warmup_dir}/Dojofile"
# generate Dojofile, otherwise Dojofile would contain bash variables and we
# want it to be just key=value data
echo -e "DOJO_DRIVER=docker" > "${dojofile}"
echo -e "DOJO_DOCKER_IMAGE=\"${base_image}\"" >> "${dojofile}"
echo -e "DOJO_DOCKER_OPTIONS=\"-v ${warmup_dir}/warmup.sh:/tmp/warmup.sh\"" >> "${dojofile}"

cd "${warmup_dir}" && dojo --rm=false /tmp/warmup.sh
if [ -f "${warmup_dir}/dojorc.txt" ]; then
  container_name=$(cat "${warmup_dir}/dojorc.txt")
elif [ -f "${warmup_dir}/dojorc" ]; then
  # TODO: in the future, after IDE 6.0.0, we should source dojorc if dojorc.txt does not exist
  container_name=$(cat "${warmup_dir}/dojorc")
else
  echo "neither ${warmup_dir}/dojorc nor ${warmup_dir}/dojorc.txt exist. Cannot tell docker container name."
  exit 1
fi
# https://aitraders.tpondemand.com/entity/9928
docker commit --change='CMD ["/bin/bash"]' --change='ENTRYPOINT ["/usr/bin/tini", "-g", "--", "/usr/bin/entrypoint.sh"]' "${container_name}" "${docker_tag}"
docker push "${docker_tag}"
docker tag "${docker_tag}" "${docker_tag_latest}"
docker push "${docker_tag_latest}"
docker rm "${container_name}"

exit 0

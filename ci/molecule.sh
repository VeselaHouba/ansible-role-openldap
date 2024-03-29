#!/usr/bin/env bash
if [ "${MOLECULE_IMAGE}" == "" ]; then
  echo "Variable MOLECULE_IMAGE not set, using default"
  MOLECULE_IMAGE=geerlingguy/docker-debian10-ansible
fi
export MOLECULE_IMAGE

docker \
  run \
  --rm \
  -it \
  -v "$(pwd):/tmp/role" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -w /tmp/role \
  -e MOLECULE_NO_LOG=false \
  -e MOLECULE_IMAGE \
  -e MOLECULE_DOCKER_COMMAND \
  veselahouba/molecule  bash -c "
  flake8 && \
  yamllint . && \
  ansible-lint && \
  molecule ${*}"

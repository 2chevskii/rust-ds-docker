#!/bin/bash

set -exuo pipefail

CREATION_TIME=$(date -u --rfc-3339=ns | sed 's/\s/T/g')

echo "Building Rust Dedicated Server $IMAGE_TYPE image"
echo "Build time: $CREATION_TIME"
echo "Branch name: $GIT_REF_NAME"
echo "Commit hash: $GIT_SHA"

docker build \
  --build-arg "CREATION_TIME=$CREATION_TIME" \
  --build-arg "BRANCH_NAME=$GIT_REF_NAME" \
  --build-arg "COMMIT_HASH=$GIT_SHA" \
  -t "ghcr.io/2chevskii/rust-dedicated-server:$IMAGE_TYPE" \
  -t "ghcr.io/2chevskii/rust-dedicated-server:$IMAGE_TYPE-$GIT_REF_NAME" \
  -t "ghcr.io/2chevskii/rust-dedicated-server:$IMAGE_TYPE-$GIT_SHA" \
  -t "docker.io/2chevskii/rust-dedicated-server:$IMAGE_TYPE" \
  -t "docker.io/2chevskii/rust-dedicated-server:$IMAGE_TYPE-$GIT_REF_NAME" \
  -t "docker.io/2chevskii/rust-dedicated-server:$IMAGE_TYPE-$GIT_SHA" \
  -f "docker/$IMAGE_TYPE/Dockerfile" \
  "docker/$IMAGE_TYPE"

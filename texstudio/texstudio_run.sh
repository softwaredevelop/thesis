#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# TexStudio
# http://texstudio.sourceforge.net/
#
# TexStudio is a LaTeX editor that integrates many tools needed to develop documents with LaTeX, in just one application.
#

set -e

RUN=${1:-"run"}
IMAGE=${2:-"texstudio:1"}

# texstudio_image=$(podman images --format "{{.Repository}}:{{.Tag}}" | grep texstudio)

# texstudio_run=$(
#   podman run \
#     --interactive \
#     --tty \
#     --volume /tmp/.X11-unix:/tmp/.X11-unix \
#     --mount type=bind,source=${PWD},target=/texstudio \
#     --env DISPLAY=unix${DISPLAY} \
#     --name texstudio \
#     ${IMAGE}
# )

# texstudio_start=$(
#   podman start \
#     --interactive \
#     texstudio
# )

if [ "${RUN}" = "run" ]; then
  podman run \
    --interactive \
    --tty \
    --volume /tmp/.X11-unix:/tmp/.X11-unix \
    --mount type=bind,source=${PWD},target=/texstudio \
    --env DISPLAY=unix${DISPLAY} \
    --name texstudio \
    ${IMAGE}
elif [ "${RUN}" = "start" ]; then
  podman start \
    --interactive \
    texstudio
fi

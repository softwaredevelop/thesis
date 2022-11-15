#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# TexStudio
# http://texstudio.sourceforge.net/
#
# TexStudio is a LaTeX editor that integrates many tools needed to develop documents with LaTeX, in just one application.
#

set -e

texstudio_f="$(
  cat <<'EOF'
ARG VARIANT=latest
FROM docker.io/softwaredevelop/latex:${VARIANT}
RUN \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    apt-utils \
    texstudio; \
    apt-get autoremove; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*
WORKDIR /texstudio
ENV MESA_LOADER_DRIVER_OVERRIDE i965
ENV XDG_RUNTIME_DIR /tmp/runtime-root
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["texstudio"]
EOF
)"

texstudio_image=$(podman images --format "{{.Repository}}:{{.Tag}}" | grep texstudio)

texstudio_build=$(
  podman build --no-cache --build-arg VARIANT=latest --tag texstudio:1 -f- . <<<${texstudio_f} 2>&1
)

texstudio_run=$(
  podman run \
    --interactive \
    --tty \
    --rm \
    --volume /tmp/.X11-unix:/tmp/.X11-unix \
    --mount type=bind,source=${PWD},target=/texstudio \
    --env DISPLAY=unix${DISPLAY} \
    --name texstudio \
    ${texstudio_image}
)

if [ -z "${texstudio_image}" ]; then
  echo "${texstudio_build}"
  echo "xhost +local:podman"
  ${texstudio_run}
else
  echo "xhost +local:podman"
  ${texstudio_run}
fi

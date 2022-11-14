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

texstudio_build=$(
  podman build --no-cache --build-arg VARIANT=latest --tag texstudio:1 -f- . <<<${texstudio_f} 2>&1
)

if [ -z "${texstudio_build}" ]; then
  echo "Error: texstudio build failed."
  exit 1
fi

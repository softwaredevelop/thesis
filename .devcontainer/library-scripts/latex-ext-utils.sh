#!/usr/bin/env bash
# -*- coding: utf-8 -*-

set -e

if [ "$(id -u)" -ne 0 ]; then
  echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
  exit 1
fi

function apt_get_update_if_needed() {
  if [ ! -d "/var/lib/apt/lists" ] || [ "$(ls /var/lib/apt/lists/ | wc -l)" -eq 0 ]; then
    apt-get update
  fi
}

function check_packages() {
  if ! dpkg --status "$@" >/dev/null 2>&1; then
    apt_get_update_if_needed
    apt-get install --no-install-recommends --assume-yes "$@"
  fi
}

export DEBIAN_FRONTEND=noninteractive

if ! command -v cpan >/dev/null 2>&1 || ! command -v perl >/dev/null 2>&1 || ! command -v cpanm >/dev/null 2>&1; then
  apt_get_update_if_needed
  check_packages \
    perl \
    cpanminus
fi

cpanm YAML::Tiny File::HomeDir Log::Dispatch::File
perl -MCPAN -e 'install "File::HomeDir"'

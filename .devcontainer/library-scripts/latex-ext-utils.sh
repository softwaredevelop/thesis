#!/usr/bin/env bash
# -*- coding: utf-8 -*-

set -e

export DEBIAN_FRONTEND=noninteractive

if [[ -d "/var/lib/apt/lists" && $(ls /var/lib/apt/lists/ | wc -l) -eq 0 ]]; then
  if apt-get update; then
    LISTS_UPDATED=0
  fi
fi

if (("$LISTS_UPDATED" == 0)); then
  package_list="gcc \
        build-essential"
  apt-get install --no-install-recommends --assume-yes $package_list
  if command -v cpan >/dev/null 2>&1 && command -v perl >/dev/null 2>&1; then
    /usr/bin/cpan Log::Dispatch::File YAML::Tiny
    /usr/bin/perl -MCPAN -e 'install "File::HomeDir"'
  fi
fi

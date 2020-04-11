#!/usr/bin/env bash
set -euo pipefail

if [ "$(id --user)" != 0 ]; then
  echo Must be run as root! >&2
  exit 1
fi

if [ ! -f /usr/bin/python ]; then
  pacman --sync --refresh --noconfirm python
fi

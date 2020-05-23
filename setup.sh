#!/usr/bin/env bash
set -euo pipefail

script_dir="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! which python3 >/dev/null; then
  echo Could not find \`python3\` on the PATH! Exiting. >&2
  exit 1
fi

if ! which pip3 >/dev/null; then
  echo Could not find \`pip3\` on the PATH! Exiting. >&2
  exit 1
fi

echo Installing Python Packages... >&2
pip3 install --requirement "$script_dir/requirements.txt"

echo Installing Ansible Roles... >&2
ansible-galaxy role install --role-file "$script_dir/requirements.yml"

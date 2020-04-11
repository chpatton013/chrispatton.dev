#!/usr/bin/env bash
set -euo pipefail

inventory_file="$1"
shift

ansible-playbook --inventory-file "$inventory_file" "$@" ansible/provision.playbook.yml

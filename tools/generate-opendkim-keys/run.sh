#!/usr/bin/env bash
set -euo pipefail

script_dir="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

output_dir="$1"

if [ ! -e "$output_dir" ]; then
  echo No such file or directory: $output_dir >&2
  exit 1
fi
if [ ! -d "$output_dir" ]; then
  echo Not a directory: $output_dir >&2
  exit 1
fi

output_dir="$(builtin cd "$output_dir" && pwd)"

export DKIM_SIZE="${DKIM_SIZE:-2048}"
export DKIM_SELECTOR="${DKIM_SELECTOR:-mail}"
export DKIM_ALGORITHMS="${DKIM_ALGORITHMS:-sha256}"

docker build --rm --tag=generate-opendkim-keys "$script_dir/image" >&2
docker run \
  --env=DKIM_SIZE \
  --env=DKIM_SELECTOR \
  --env=DKIM_ALGORITHMS \
  --env=DKIM_DOMAIN \
  --volume="$output_dir:/keys:rw" \
  generate-opendkim-keys

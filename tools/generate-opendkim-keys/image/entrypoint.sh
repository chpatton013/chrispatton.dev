#!/usr/bin/env bash
set -euo pipefail

[ -n "$DKIM_SIZE" ]
[ -n "$DKIM_SELECTOR" ]
[ -n "$DKIM_ALGORITHMS" ]
[ -n "$DKIM_DOMAIN" ]

exec opendkim-genkey \
  --append-domain \
  --bits="$DKIM_SIZE" \
  --directory=/keys \
  --domain="$DKIM_DOMAIN" \
  --hash-algorithms="$DKIM_ALGORITHMS" \
  --restrict \
  --selector="$DKIM_SELECTOR" \
  "$@"

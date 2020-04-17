#!/usr/bin/env bash
set -euo pipefail

[ -n "$DOVECOT_SCHEME" ]
[ -n "$DOVECOT_PASSWORD" ]

exec doveadm pw -s "$DOVECOT_SCHEME" -p "$DOVECOT_PASSWORD"

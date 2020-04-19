#!/usr/bin/env bash
set -euo pipefail

if [ "$(id --user)" != 0 ]; then
  echo Must be run as root! >&2
  exit 1
fi

if [ ! -f /usr/bin/openssl ]; then
  pacman --sync --refresh --noconfirm openssl
fi

if [ ! -d /etc/letsencrypt/live/example.com/ ]; then
  mkdir --parents /etc/letsencrypt/live/example.com/

  cat <<EOF >/etc/letsencrypt/live/example.com/config.ini
[ req ]
default_bits       = 4096
default_md         = sha512
prompt             = no
encrypt_key        = no
distinguished_name = req_distinguished_name
[ req_distinguished_name ]
countryName            = "US"                     # C=
stateOrProvinceName    = "California"             # ST=
localityName           = "Los Angeles"            # L=
postalCode             = "90001"                  # L/postalcode=
streetAddress          = "123 Example St"         # L/street=
organizationName       = "testing"                # O=
organizationalUnitName = "Testing"                # OU=
commonName             = "example.com"            # CN=
emailAddress           = "webmaster@example.com"  # CN/emailAddress=
EOF

  openssl req \
    -config /etc/letsencrypt/live/example.com/config.ini \
    -newkey rsa:4096 -nodes -keyout /etc/letsencrypt/live/example.com/privkey.pem \
    -x509 -days 365 -out /etc/letsencrypt/live/example.com/cert.pem
  touch /etc/letsencrypt/live/example.com/chain.pem
  cp \
    /etc/letsencrypt/live/example.com/cert.pem \
    /etc/letsencrypt/live/example.com/fullchain.pem
fi

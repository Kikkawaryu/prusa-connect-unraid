#!/bin/sh
set -e

PUID="${PUID:-99}"
PGID="${PGID:-100}"

mkdir -p /config/config.d /data /files /storage
chown -R "${PUID}:${PGID}" /config/config.d /data /files /storage

exec gosu "${PUID}:${PGID}" "$@"

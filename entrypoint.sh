#!/bin/sh
set -e

PUID="${PUID:-99}"
PGID="${PGID:-100}"

mkdir -p /config/config.d /data /files /storage

if [ ! -f /config/config.yaml ] && [ -f /defaults/config.yaml ]; then
    cp /defaults/config.yaml /config/config.yaml
fi

chown -R "${PUID}:${PGID}" /config /data /files /storage

exec gosu "${PUID}:${PGID}" "$@"

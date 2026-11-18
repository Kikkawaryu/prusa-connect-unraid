#!/bin/sh
set -e

PUID="${PUID:-99}"
PGID="${PGID:-100}"

mkdir -p /config/config.d /data /files /storage

if [ ! -f /config/config.yaml ] && [ -f /defaults/config.yaml ]; then
    cp /defaults/config.yaml /config/config.yaml
fi

chown -R "${PUID}:${PGID}" /config /data /files /storage

rm -f /tmp/.X99-lock
Xvfb :99 -screen 0 1024x768x24 -ac >/dev/null 2>&1 &

exec gosu "${PUID}:${PGID}" "$@"

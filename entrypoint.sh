#!/bin/sh
set -e

mkdir -p /config/config.d /data /files /storage

if [ ! -f /config/config.yaml ]; then
  cp /opt/default-config.yaml /config/config.yaml
fi

chown -R 10001:10001 /config/config.d /data /files /storage
chown 10001:10001 /config /config/config.yaml 2>/dev/null || true

exec setpriv --reuid=10001 --regid=10001 --init-groups /prusa_connect "$@"

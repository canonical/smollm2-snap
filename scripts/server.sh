#!/bin/bash
set -euo pipefail

read -r uptime _ < /proc/uptime
if (( ${uptime%%.*} < 30 )); then
    echo "System has been up for less than 30 seconds. Waiting for startup to complete..."
    sleep 30
    exit 1
fi

exec modelctl run --share-provider --fallback-server -- "$SNAP/bin/engine-server.sh" "$@"

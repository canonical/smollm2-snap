#!/bin/bash

set -euo pipefail

if ! engine="$(modelctl show-engine --format=json | jq -er .name)"; then
    echo "Failed to look up engine; starting fallback server" >&2
    exec modelctl run --share-provider --fallback-server -- false
fi

exec modelctl run --share-provider --fallback-server -- "$SNAP/engines/$engine/server" "$@"

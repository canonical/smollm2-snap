#!/bin/bash
set -euo pipefail

exec modelctl run --share-provider --fallback-server -- "$SNAP/bin/engine-server.sh" "$@"

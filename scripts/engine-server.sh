#!/bin/bash
set -euo pipefail

engine="$(modelctl engine --format=json | jq -er .name)"

exec "$SNAP/engines/$engine/server" "$@"
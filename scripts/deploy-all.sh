#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"

"$DIR/deploy-live.sh" "$@"
"$DIR/deploy-rest.sh" "$@"
"$DIR/deploy-space.sh" "$@"

echo "All sites deployed."


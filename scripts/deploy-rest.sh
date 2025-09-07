#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$REPO_DIR/sites/rest/"
DEST="/var/www/stateofshit-rest/"

DRY=""
if [[ "${1:-}" == "-n" || "${1:-}" == "--dry-run" ]]; then
  DRY="--dry-run -v"
  echo "[dry-run] Showing actions only"
fi

sudo rsync -a --delete --exclude ".git" $DRY "$SRC" "$DEST"
echo "Deployed rest site to $DEST"


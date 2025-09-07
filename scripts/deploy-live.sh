#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$REPO_DIR/sites/live/"
DEST="/var/www/stateofshit/"

DRY=""
if [[ "${1:-}" == "-n" || "${1:-}" == "--dry-run" ]]; then
  DRY="--dry-run -v"
  echo "[dry-run] Showing actions only"
fi

sudo rsync -a --delete --exclude ".git" $DRY "$SRC" "$DEST"
echo "Deployed live site to $DEST"


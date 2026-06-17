#!/usr/bin/env bash
# Fetch catppuccin starship theme: https://github.com/catppuccin/starship
set -euo pipefail
source "$(dirname "$0")/../lib/common.sh"

FORCE=0
[ "${1:-}" = --force ] && FORCE=1

cfg="$STOW_DIR/starship/.config/starship.toml"
if [ -f "$cfg" ] && [ "$FORCE" -eq 0 ]; then
  skip "catppuccin starship.toml (use --force to refresh)"
  exit 0
fi

mkdir -p "$(dirname "$cfg")"
log "Fetching catppuccin/starship theme"
curl -fsSL -o "$cfg" \
  https://raw.githubusercontent.com/catppuccin/starship/main/starship.toml
sed -i 's/palette = "catppuccin_macchiato"/palette = "catppuccin_mocha"/' "$cfg"
if ! grep -q '^scan_timeout' "$cfg"; then
  sed -i '/^palette = /i\
# NFS home: git/repo scans can exceed the default 30ms timeout.\
scan_timeout = 10000\
command_timeout = 1000\
' "$cfg"
fi
sed -i '1i# Catppuccin for Starship — https://github.com/catppuccin/starship' "$cfg"
ok "starship.toml (catppuccin mocha) -> $cfg"

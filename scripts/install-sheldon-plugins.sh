#!/usr/bin/env bash
# Clone zsh plugins declared in stow/sheldon/.config/sheldon/plugins.toml
# into the vendored data dir (gitignored), via `sheldon lock`.
set -euo pipefail
source "$(dirname "$0")/../lib/common.sh"
init_tools_dir

# Read config straight from the repo (don't depend on the ~/.config symlink),
# and clone into the vendored data dir.
cfg_dir="$STOW_DIR/sheldon/.config/sheldon"
have sheldon || { warn "sheldon not installed (run scripts/tools/sheldon.sh)"; exit 1; }
[ -f "$cfg_dir/plugins.toml" ] || { warn "missing $cfg_dir/plugins.toml"; exit 1; }

export SHELDON_CONFIG_DIR="$cfg_dir"
export SHELDON_DATA_DIR="$DOTFILES/vendor/sheldon"
mkdir -p "$SHELDON_DATA_DIR"
log "sheldon lock -> $SHELDON_DATA_DIR"
if sheldon lock; then
  ok "zsh plugins cloned"
else
  warn "sheldon lock failed (no GitHub access?) — re-run later"
fi

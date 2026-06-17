#!/usr/bin/env bash
# Symlink stow/<pkg>/... into $HOME via stow-python.
set -euo pipefail
source "$(dirname "$0")/../lib/common.sh"

[ -x "$STOW" ] || { warn "run scripts/install-stow.sh first"; exit 1; }

# stow-python doesn't adopt existing paths, so clear anything occupying a
# managed target that isn't already our link (regular files, stale/foreign
# symlinks). Then restow cleanly.
clean_conflicts() {
  local pkg rel target
  for pkg in $(discover_packages); do
    while IFS= read -r rel; do
      rel="${rel#./}"
      target="$HOME/$rel"
      if [ -L "$target" ]; then
        case "$(readlink "$target")" in
          *"dotfiles"*"/stow/$pkg/"*) ;;   # already ours
          *) rm -f "$target" ;;
        esac
      elif [ -e "$target" ]; then
        # Parent dirs may already be stow symlinks; don't delete the repo source.
        resolved="$(readlink -f "$target" 2>/dev/null || true)"
        case "$resolved" in
          "$STOW_DIR"/*) continue ;;
        esac
        rm -f "$target"
      fi
    done < <(cd "$STOW_DIR/$pkg" && find . -mindepth 1 \( -type f -o -type l \)) || true
  done
}

PKGS=($(discover_packages))
[ "${#PKGS[@]}" -gt 0 ] || { warn "no stow packages in $STOW_DIR"; exit 1; }

clean_conflicts
log "Stowing: ${PKGS[*]}"
"$STOW" -R -d "$STOW_DIR" -t "$HOME" "${PKGS[@]}"
ok "dotfiles stowed"

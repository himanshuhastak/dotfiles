#!/usr/bin/env bash
# Vendor stow-python (no Perl needed): https://github.com/isarandi/stow-python
set -euo pipefail
source "$(dirname "$0")/../lib/common.sh"

mkdir -p "$DOTFILES/bin"
if [ ! -f "$DOTFILES/bin/stow.py" ]; then
  log "Fetching stow-python"
  curl -fsSL -o "$DOTFILES/bin/stow.py" \
    https://raw.githubusercontent.com/isarandi/stow-python/main/bin/stow
  # box has python3 but no `python`; pin the shebang.
  sed -i '1s|python$|python3|' "$DOTFILES/bin/stow.py"
fi
if [ ! -x "$DOTFILES/bin/stow" ]; then
  cat > "$DOTFILES/bin/stow" <<'EOF'
#!/usr/bin/env bash
exec python3 "$(dirname "$0")/stow.py" "$@"
EOF
  chmod +x "$DOTFILES/bin/stow"
fi
ok "stow-python -> $DOTFILES/bin/stow"

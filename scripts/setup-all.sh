#!/usr/bin/env bash
# End-to-end dotfiles bootstrap.
#   setup-all.sh [--skip-fonts] [--skip-tools] [--fetch-theme]
set -uo pipefail

SCRIPTS="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPTS/../lib/common.sh"

SKIP_FONTS=0
SKIP_TOOLS=0
THEME_ARGS=()
for arg in "$@"; do
  case "$arg" in
    --skip-fonts)  SKIP_FONTS=1 ;;
    --skip-tools)  SKIP_TOOLS=1 ;;
    --fetch-theme) THEME_ARGS+=(--force) ;;
    *) warn "unknown arg: $arg" ;;
  esac
done

run() {
  printf '\n\033[1;35m######\033[0m %s\n' "$1"
  bash "$SCRIPTS/$1" "${@:2}"
}

run install-stow.sh
run fetch-starship-theme.sh "${THEME_ARGS[@]}"
[ "$SKIP_TOOLS" -eq 0 ] && run install-tools.sh || skip "tools (--skip-tools)"
run stow-dotfiles.sh
run install-sheldon-plugins.sh
[ "$SKIP_FONTS" -eq 0 ] && run install-fonts.sh || skip "fonts (--skip-fonts)"
run fix-task-hooks.sh

init_tools_dir
echo
ok "Setup complete."
echo "  tools:   $BIN"
echo "  stow:    $STOW"
echo "  theme:   ~/.config/starship.toml (catppuccin mocha)"
have starship && echo "  prompt:  starship"
have sheldon  && echo "  zsh:     sheldon plugins -> $DOTFILES/vendor/sheldon"
have zellij   && echo "  mux:     zellij (run: zellij)"
[ -f "$FONT_DIR/JetBrainsMonoNerdFont-Regular.ttf" ] && \
  echo "  font:    JetBrainsMono Nerd Font (select in terminal)"
echo
echo "Open a fresh shell:  exec zsh   (or exec bash)"

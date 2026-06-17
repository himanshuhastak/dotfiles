#!/usr/bin/env bash
# Install every CLI tool by running each scripts/tools/<tool>.sh.
# Usage: install-tools.sh [tool ...]   (no args = all)
set -uo pipefail
SCRIPTS="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPTS/../lib/common.sh"
init_tools_dir

# Stable, dependency-aware order (starship/sheldon/zellij last is fine).
order="fzf eza fd sd bat delta duf gdu just jq yq choose rg zoxide broot procs dust \
tldr lazygit atuin direnv bugwarrior parallel starship zsh sheldon zellij bash blesh oc-rsync miniserve pipr"

tools=("$@")
[ "${#tools[@]}" -eq 0 ] && tools=($order)

failed=""
for t in "${tools[@]}"; do
  script="$SCRIPTS/tools/$t.sh"
  if [ ! -f "$script" ]; then
    warn "no installer for '$t'"
    failed="$failed $t"
    continue
  fi
  bash "$script" || failed="$failed $t"
done

echo
if [ -n "$failed" ]; then
  warn "failed:$failed"
  warn "re-run individually, e.g.:  scripts/tools/<tool>.sh"
  exit 1
fi
ok "all tools installed -> $BIN"

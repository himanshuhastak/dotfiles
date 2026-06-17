#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../../lib/common.sh"
init_tools_dir
install_tool starship starship/starship 'starship-{arch}-unknown-linux-musl.tar.gz'

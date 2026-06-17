#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../../lib/common.sh"
init_tools_dir
install_tool fzf junegunn/fzf 'fzf-{ver}-linux_{goarch}.tar.gz'

#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../../lib/common.sh"
init_tools_dir
install_tool just casey/just 'just-{ver}-{arch}-unknown-linux-musl.tar.gz'

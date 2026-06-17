#!/usr/bin/env bash
# taskwarrior (task) — built from source (no prebuilt static binary exists).
# NOTE: taskwarrior 3.x needs Rust/cargo (TaskChampion backend) in addition to
# cmake + a C++17 compiler. Opt-in: not part of the default install order.
set -euo pipefail
source "$(dirname "$0")/../../lib/common.sh"
init_tools_dir
command -v cargo >/dev/null 2>&1 \
  || warn "task: cargo (rust) is usually required to build taskwarrior 3.x"
build_from_source task GothenburgBitFactory/taskwarrior 'task-{ver}.tar.gz' task

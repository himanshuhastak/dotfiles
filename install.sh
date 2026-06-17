#!/usr/bin/env bash
# Bootstrap entrypoint — runs the full setup.
# Individual steps live in scripts/*.sh ; per-tool installers in scripts/tools/*.sh
exec bash "$(dirname "$0")/scripts/setup-all.sh" "$@"

#!/bin/bash
set -euo pipefail

CONSTITUTION="${CLAUDE_PLUGIN_ROOT}/hooks/constitution.md"

if [ -f "$CONSTITUTION" ]; then
  cat "$CONSTITUTION"
fi

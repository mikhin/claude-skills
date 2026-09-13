#!/usr/bin/env bash
# SessionStart hook: prints this skill into the session context instead of waiting for a trigger.
set -euo pipefail
root="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
awk 'BEGIN{fm=0} /^---$/{fm++; next} fm>=2' "$root/skills/decisions/SKILL.md"
echo

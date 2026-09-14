#!/usr/bin/env bash
# SessionStart hook: prints the always-on skills into the session context.
# Wired up through .claude-plugin/plugin.json -> hooks/hooks.json when the plugin is installed.
# Pick a different set with AUTOLOAD_SKILLS="a b c".
set -euo pipefail
root="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
for name in ${AUTOLOAD_SKILLS:-decisions stack answers}; do
  file="$root/skills/$name/SKILL.md"
  [ -f "$file" ] || continue
  awk 'BEGIN{fm=0} /^---$/{fm++; next} fm>=2' "$file"
  echo
done

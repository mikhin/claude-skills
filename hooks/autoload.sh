#!/usr/bin/env bash
# SessionStart hook: prints always-on skills into the session context.
# Wire it up in ~/.claude/settings.json:
#   "hooks": { "SessionStart": [ { "matcher": "",
#     "hooks": [ { "type": "command", "command": "~/Code/claude-skills/hooks/autoload.sh" } ] } ] }
# Skills to autoload, space-separated; override with AUTOLOAD_SKILLS.
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
for name in ${AUTOLOAD_SKILLS:-yuri-decisions yuri-stack}; do
  file="$root/skills/$name/SKILL.md"
  [ -f "$file" ] || continue
  awk 'BEGIN{fm=0} /^---$/{fm++; next} fm>=2' "$file"
  echo
done

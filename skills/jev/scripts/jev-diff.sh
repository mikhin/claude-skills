#!/usr/bin/env bash
# Scores every changed file of the current branch with typesafe-ai/jev via Vercel AI Gateway.
# Usage: jev-diff.sh [base-ref]   (base defaults to the PR base, else the release/* branch, else main)
# Needs AI_GATEWAY_API_KEY, jq, curl. Questions: ./questions.json, overridable by .jev-questions.json in the repo root.
set -euo pipefail

: "${AI_GATEWAY_API_KEY:?AI_GATEWAY_API_KEY is not set}"
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="$(git rev-parse --show-toplevel)"
questions_file="$root/.jev-questions.json"
[ -f "$questions_file" ] || questions_file="$here/questions.json"

base="${1:-}"
if [ -z "$base" ]; then
  base="$(gh pr view --json baseRefName -q .baseRefName 2>/dev/null || true)"
fi
if [ -z "$base" ]; then
  base="$(git branch -r --format='%(refname:short)' | grep -m1 'release/' | sed 's#^origin/##' || true)"
fi
base="${base:-main}"
git rev-parse --verify -q "origin/$base" >/dev/null && base="origin/$base"

files="$(git diff --name-only "$base"...HEAD; git diff --name-only; git ls-files --others --exclude-standard)"
files="$(printf '%s\n' "$files" | sort -u | grep -vE '\.(spec|test)\.[jt]sx?$|^src/api/|^pnpm-lock' || true)"
[ -n "$files" ] || { echo "no changed files against $base" >&2; exit 0; }

diff_of() { git diff "$base" -- "$1"; }
spec_changed() {
  local stem="${1%.*}"
  printf '%s\n' "$files" | grep -q "^${stem}\.spec\." && return 0
  git diff --name-only "$base"...HEAD | grep -q "^${stem}\.spec\."
}

while IFS= read -r file; do
  diff="$(diff_of "$file" | head -c 60000)"
  [ -n "$diff" ] || continue
  spec=false; spec_changed "$file" && spec=true
  body="$(jq -n --arg file "$file" --arg diff "$diff" --argjson spec "$spec" --slurpfile q "$questions_file" \
    '{state: {file: $file, specChangedInSameDiff: $spec, diff: $diff}, questions: $q[0]}')"
  curl -sS -m 60 -X POST https://ai-gateway.vercel.sh/v4/ai/evaluation-model \
    -H "Authorization: Bearer $AI_GATEWAY_API_KEY" -H "Content-Type: application/json" \
    -H "ai-gateway-protocol-version: 0.0.1" \
    -H "ai-evaluation-model-specification-version: 4" \
    -H "ai-model-id: typesafe-ai/jev" \
    -d "$body" \
  | jq -c --arg file "$file" '{file: $file, answers: (.answers // .error)}'
done <<< "$files" | jq -s 'sort_by(-(.answers.bug_risk.score // 0))'

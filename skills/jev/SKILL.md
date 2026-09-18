---
name: jev
description: Score the changed files of the current branch with Jev (typesafe-ai evaluation model via Vercel AI Gateway) — bug risk, logic in components, missing tests, published-snapshot writes. Triggers — "/jev", "run jev", "jev the diff", «прогони jev», «что скажет jev».
---

# jev

Cheap triage of a PR's files before a human or a model reads them. Jev does not read code the way an LLM does: it scores a state against a rubric and returns probabilities. Treat the output as "which files deserve attention", not as findings.

## Run

```
bash "$CLAUDE_PLUGIN_ROOT/skills/jev/scripts/jev-diff.sh" [base-ref]
```

Needs `AI_GATEWAY_API_KEY` in the environment (a Vercel AI Gateway key of the team that pays), `jq`, `gh`. Base resolves like all-check: PR base, else the `release/*` branch, else `main`. Specs, `src/api/` and lockfiles are skipped; each remaining file goes in as its own diff, capped at 60 KB.

Questions live in `scripts/questions.json`; a repo can override them with `.jev-questions.json` at its root.

## Report

One line per file, sorted by `bug_risk.score` descending: file → score → the booleans that came back above 0.5. Nothing else. A run costs a fraction of a cent.

## Evaluation period

While Jev is on trial, after every run note in memory what it flagged and what the review (human, Copilot, codex) actually found, so the trial ends on data, not on impression.

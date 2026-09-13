---
name: all-check
description: Run every check the project has except e2e, scoped to the files of the current PR or branch, and report one line per check. Triggers — "/all-check", "run all the checks", "all checks except e2e", "check the PR files", «запусти все проверки», «прогони проверки по файлам PR».
---

# all-check

Goal: in one pass, run everything this project knows how to check except e2e, and report briefly —
one line per check, findings limited to the files of the PR.

## 1. The PR files

1. Base: `gh pr view --json baseRefName -q .baseRefName`; with no PR, the `release/*` branch the
   current one was cut from (`git branch -r | grep release/`), otherwise `main`.
2. List: `git diff --name-only origin/<base>...HEAD` plus uncommitted work (`git status --short`).
   Save it to a file in the scratchpad and use that file from then on.
3. In zsh a variable is not word-split: pass the list as `${=FILES}` or through `xargs`.

## 2. Which checks

Read `scripts` in `package.json` and sort them into the categories below. Run everything that is
there and invent nothing: no script, no check.

| Category | Typical scripts | Scope |
| --- | --- | --- |
| lint | `lint:check`, oxlint, eslint | PR files |
| format | `format:check`, oxfmt, prettier | PR files |
| types | `tsc`, `typecheck` | whole project |
| unit tests | `test`, vitest, jest | `vitest run --changed origin/<base>` (related tests); otherwise the PR's specs plus the specs of changed sources |
| mutation | `mutate`, stryker | `--mutate 'a.ts,b.ts'` as one comma-separated list of changed files that fall inside the config's `mutate` glob (usually services/stores/lib); always `--force` — the incremental cache lies when a file has only just gained a spec |
| build | `build` | whole project |
| duplication | `jscpd`, `dup` | whole project, filter the output by the base names of the PR files |
| architecture drift | `drift`, `arch*` | whole project, show the output in full (it is short) |
| dead code and exports | `knip`, `dead*` | whole project, filter by PR files, show the summary lines |
| React health | `react-doctor` | whole project, summary only |

Skip: anything matching `e2e`, `playwright`, `staging`, `codegen`, `dev`, `deploy`,
`strip-comments`, `*:fix`, `*:write`, `openapi-ts`, and `mutate` when no service files changed.

## 3. How to run them

- Light ones (lint, format, tsc) in a single call. Heavy ones (vitest, stryker, build, scanners) in
  parallel calls, but never alongside e2e: they starve each other on CPU.
- macOS has no `timeout`; cap them with the tool's own timeout, 10 minutes for Stryker and build.
- Stryker prints survivors for the whole incremental set: read only the table rows and the
  `[Survived]` blocks for PR files. Put the full output in a scratchpad file and grep it.
- A surviving mutant is a missing assertion, not a number. Leave equivalent ones and name them.

## 4. The report

A table: check → result → findings in PR files, one line each. On a separate line, findings that
predate the PR (confirm with `git blame` or a run on the base) — do not fix those silently.
Change nothing without asking, except formatting of files the PR already touches. If everything is
clean, say so in one sentence, no table.

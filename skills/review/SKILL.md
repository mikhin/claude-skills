---
name: review
description: How Yuri Mikhin wants bugs investigated and review findings handled — the "why didn't the tests catch it" rule, test-before-fix order, numbered findings with file:line anchors and per-item verdicts, what may block a merge, and when a review loop stops. Triggers — "review this", "findings", "what do you think of this review", "why is this flaky", "a bug in production", "another round", «ревью», «находки», «почему тесты не поймали», «ещё раунд».
---

# Reviewing and debugging with me

## Every bug ends with: why didn't the tests catch it?

Answer it in the same message as the fix. Name the gap: no test on this path; a test that asserts shape, not content; a test that was skipped or never ran here; not testable at this layer, and here is the layer where it is. "Hard to test" is the start of an answer.

## Reproduce, failing test, then fix

A fix without the test that would have caught it is unfinished. If a class of bugs keeps escaping, the finding is about the harness, not the line.

## Findings

Numbered, most severe first, one line each, anchored:

```
1. path/to/file.ts:120 — what is wrong and what it breaks for the user.
```

No categories, no summary on top, no severity theatre. An empty list is a fine result.

## Arbitrating someone else's review

A verdict per item, never a digest:

```
1. <item> — accepted: <what changes>
2. <item> — rejected: <the fact that kills it, file:line>
3. <item> — ticket: <one line why it waits>
```

Before accepting, try to refute it against the code: in one measured week 42 of 59 per-hunk LLM findings were refuted, and mutation testing was 4 for 4. Silent compliance with a wrong finding is worse than arguing with a right one.

## Scope: the ticket, plus one hop

Fix in this PR what breaks the user on the ticket's path, and what the fix itself touches. Everything else a review finds — adjacent machinery, older debt, "while we're here" — goes to a Linear ticket with one line of why. A finding is not a reason to grow the diff; on #257 that turned 186 lines into 1600 across eight rounds.

## What blocks a merge

Only a finding that is both confident and reaches on a normal path. A race that needs impossible timing, a limit the system never sees, a style preference: comment, not blocker. The merge gate is CI, the touched specs and Stryker on the changed lines. "The review found nothing" is never the gate — a high-effort review is built to keep finding.

## When the loop stops

Two rounds. Round two checks round one's list, it does not re-review from scratch. If round two finds as much as round one, the loop is not converging: stop, merge on the gate above, and ask what about the process let it through — that question beats round three.

## Flaky is a finding

A test that passes on retry has a cause: a race, a shared port, leaked state, a real bug. Retries and `skip` are not fixes.

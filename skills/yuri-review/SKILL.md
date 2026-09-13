---
name: yuri-review
description: How Yuri Mikhin wants bugs investigated and review findings presented — the "why didn't the tests catch it" rule, test-before-fix order, the numbered-findings format with file:line anchors and per-item verdicts, and how to arbitrate another model's review. Triggers — "review this", "findings", "what do you think of this review", "why is this flaky", "a bug in production", «ревью», «находки», «почему тесты не поймали», «что думаешь про это ревью».
---

# Reviewing and debugging with me

## Every bug ends with one question: why didn't the tests catch it?

Ask it yourself, before I do, and answer it in the same message as the fix. It is the single most repeated thing I say. Acceptable answers name the gap:

- no test covers this path at all
- a test covers it but asserts shape instead of content
- the test is there and was skipped / filtered / never ran in this config
- it is not testable at this layer, and here is the layer where it is

"Hard to test" is the start of an answer, not the end.

## Order of work: reproduce, then a failing test, then the fix

Write the test that catches it first, watch it fail, then fix. A fix delivered without the test that would have caught it is unfinished, and I will send it back.

If a whole class of bugs keeps escaping, the finding is about the harness, not the line.

## Findings format

Numbered, most severe first, one item per defect:

```
1. path/to/file.ts:120 — what is wrong, in one sentence, and what it breaks for the user.
2. ...
```

Rules:
- anchor every item to `file:line` — an unanchored claim is not checkable
- one line per item; the reasoning goes underneath only if I ask
- no severity theatre, no categories, no summary paragraph on top
- say plainly when there is nothing: an empty list is a fine result

## When you bring me someone else's review

I run other models and tools over my diffs and then arbitrate. What I need from you is a verdict per item, not a digest:

```
1. <item> — accepted: <what you will change>
2. <item> — rejected: <the fact that kills it, with its own file:line>
```

Reject with evidence. Silently complying with a wrong finding is worse than arguing with a right one — it puts a defect in the code with a review's blessing on it. If an item is right but out of scope, say so and file it, don't quietly do it.

When I ask "is this review worth anything?" I want the split: what is real, what is noise, and whether the reviewer understood the code at all.

## Flaky is a finding

A test that passes on retry is a defect with a cause — a race, a shared port, leaked state, a real product bug. Find the cause. Retries and `skip` are not fixes, and a skipped test that nobody notices is worse than a red one.

## Don't hand back problems

"Pre-existing", "not introduced by this PR", "outside the diff" are not reasons to leave a broken thing broken. If you found it and it hurts the user, fix it or tell me why it must wait.

## When the same review keeps finding things

After several rounds on the same change, stop reviewing and ask what about the process lets this through every time. That question is more valuable than round eleven.

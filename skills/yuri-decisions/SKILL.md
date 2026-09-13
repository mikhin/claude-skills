---
name: yuri-decisions
description: How Yuri Mikhin makes decisions — the questions he asks before accepting a change, where he expects answers to be looked up, and what he rejects on sight. Meant to be always on (SessionStart hook), not trigger-loaded.
---

# How I decide

## Nothing lands without a why I can repeat

My most frequent question, by a wide margin: **what is this for**. Variants: "why is this needed", "what's the point", "why this and not that", "why did you suggest 501 and not 499".

Answer the why before the how. "It's needed" / "best practice" / "cleaner" are not answers. If you cannot state what breaks without the change, the change does not exist.

When I ask which option is more correct architecturally, I want a comparison with a loser, not agreement with me. Agreeing with a bad idea of mine costs more than arguing.

## The answer usually already exists — look before inventing

Before designing anything, check whether we already decided it: git history, the tracker, chat threads, earlier Claude sessions, the memory files. I ask for this explicitly and often ("find in the Claude sessions why we decided NOT to return this", "check git history, the tracker, chat").

Say where you looked. "Not found in X, Y, Z" is a real answer; inventing a second answer next to an existing one is not.

Also check the recent past specifically: we may have shipped a fix for this last week. Regressions of our own work are the common case, not the rare one.

## A fix at one call site is not a fix

When you find a defect, find every sibling. Then pick the highest-leverage place:

1. Can a lint rule / type / schema make it unrepresentable? Do that. I ask for custom lint rules by name.
2. Otherwise fix it once where all callers route through.
3. Only then patch the reported spot.

"Fix all seven and add the rule" is the shape of answer I accept. "Fixed the one you reported" is not.

Same for duplication: two copies that drift are a defect even when both currently work.

## Layer boundaries are not negotiable

- A contract describes the shape of data, not the implementation behind it. Implementation rules live in the implementing code, on both sides.
- Don't shape a shared contract around one consumer's convenience — including our own.
- Business logic does not live in a component.
- If a decision belongs to another team, state what the contract requires and stop. Do not size their work or prescribe how they do it.

## No prose

Repos rot into slop: agent-written descriptions, restated requirements, explanations nobody reads. What an explanation would have said goes into a name, a test, or the commit message.

The same applies to tickets, plans and summaries — short, no ceremony, no repeating the same rule three times in different words.

## When I say "I don't get it"

Re-explain differently: a concrete example, smaller words, fewer clauses. Do not repeat the same sentence with more emphasis, and do not treat my not understanding as agreement. I will say "still confused" as many times as needed — that is the process working, not failing.

If I ask "so what's better in the end?" I want one recommendation with a reason, not the menu again.

## Scope is my call

Same PR or a separate ticket, now or later, in this release or the next — ask me, do not decide silently. Both answers happen often, and which one depends on things you cannot see.

## Default taste

Boring, proven, minimal custom code. Fewer moving parts beat clever. If the community already solved it, use theirs; if a native feature covers it, no dependency.

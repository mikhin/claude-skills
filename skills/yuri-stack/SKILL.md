---
name: yuri-stack
description: What Yuri Mikhin already knows and how he verifies work — the frontend checking stack he runs on every change, how he reviews layout across viewports, and the product side of his own plugins and bots. Meant to be always on (SessionStart hook), not trigger-loaded.
---

# What I know, and how I check work

Senior frontend engineer at Evil Martians. Assume the knowledge below; don't explain it to me, and don't ask me to choose things I have already standardised on.

## The checking stack

I do not trust a change because it compiles. On a normal change these are available and expected to be used:

- **typecheck + lint** — oxlint with custom rules written for this codebase; when a rule can encode an architectural constraint, I want the rule, not a review comment. Layer boundaries are lint-enforced.
- **unit tests** — Vitest over pure business logic, MSW for API mocking.
- **mutation testing** — Stryker over services/stores. A survivor is a missing assertion, usually shape asserted instead of content. The score is a detector, not a target.
- **e2e** — Playwright. Run in CI mode locally when checking flakiness; the default parallel run flakes on its own.
- **dead code / duplication** — knip-style dead-export sweeps, reachability scripts from the entry point, jscpd for copy-paste.
- **generated API clients** — the client is generated from the spec and never hand-edited; a contract change goes spec first, regenerate after.
- **production signal** — Sentry for errors, PostHog for product analytics, deploy logs when staging misbehaves.

When something escapes all of this, the interesting question is which of them should have caught it.

## Layout review

I check layout myself, across viewports, on real renders — not on a description of them. Narrow first: 320, 375, 430, then tablet, then desktop. What I look for and comment on by name:

- composition and rhythm at 320, not just "it fits"
- sticky first column and horizontal scroll behaviour on wide grids
- tables: same solution everywhere, no second implementation for the second table
- skeletons matching the real layout
- empty states and buttons at the narrowest width

"It works on desktop" is not a result. A screenshot of the actual page is.

## Contract and process knowledge

- API-first: the spec is the source of truth, the backend implements it, the client is generated. Not "the spec documents what was built".
- Tickets, releases and branch flow are already set up per project — read the repo's own notes rather than proposing a new process.
- Design lives in Figma and is the reference for UI work; if the implementation diverges, that is a finding.

## My own products

I ship and run small products solo, so the product side is mine too, and I make these calls myself:

- Figma plugins: credit packs and pricing, Lemon Squeezy checkout, free-tier generosity tuned to convert without annoying, analytics events matching the funnel, A/B at the payment step.
- Telegram bots: hosting and memory limits on Fly.io, ad monetisation through CPA networks, usage stats, watchdogs, empty-answer rate as a quality metric.

For these, "what is technically possible" is rarely the question — the question is what it does to conversion, cost, or support load.

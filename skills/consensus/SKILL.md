---
name: consensus
description: Adversarial multi-agent debate until consensus. Roles get mutually exclusive hypotheses and must refute each other; the synthesizer is the session itself (Opus) over the agents (Sonnet); exit on agreement, not on round count. Use when the answer is contested and the cost of a mistake is high: how many of what is needed, what is in scope, which option is right, what is decided versus what only looks decided. Triggers: "let the agents argue", "debate until consensus", "several rounds", "check from several sides", "adversarial", «спор агентов», «до консенсуса», «пусть поспорят», «проверь с разных сторон», «состязательно».
disable-model-invocation: false
---

# Consensus — adversarial debate until convergence

Not to be confused with `multi-agent-research`: there the roles complement each other and always do a fixed run. Here the roles **contradict** each other, and a second round happens only on the items where they did not agree.

## When not to run it

A question with a single source of truth (what is in the file, what the test returned, what is in git) — check it yourself. A debate is needed where the sources diverge, part of the decisions live in comments rather than in document bodies, and where "missing an item" costs more than "checking once more".

## Step 1. The synthesizer gathers the ground itself

Do not delegate the collection of facts you need for judging. Before launching the agents, find out yourself: what artifact is being debated, where the sources are, what is already written, what the dates of the latest edits are. A fresh revision of a document cancels any past analysis — find it first.

Large MCP responses (documents, long threads) do not fit in the context and are saved to a file. Copy them into the scratchpad and give the agents **file paths**, not the job of pulling the same data three times. Long strings are read in slices: `python3 -c 'print(open("<path>").read()[0:40000])'`.

## Step 2. One shared brief as a file

Write `BRIEF.md` in the scratchpad and reference it from every prompt. The brief contains:

1. **The question** — in one phrase, and what counts as the unit of the answer (an endpoint? a file? a scope item?). Define it strictly, otherwise the roles will argue about different things.
2. **Established facts** — what you verified yourself, marked "do not re-verify". This saves the agents half the run and keeps them from reopening what is closed.
3. **Sources** — all of them, by name, with ids and paths. On a separate line, always: the comments on documents and tickets, not only their bodies. Half of the decisions live in threads, and the bodies go stale.
4. **Rule of evidence** — an anchor is a verbatim quote with author, date and exact location (§ of the document, ticket number, link to the thread). "Common sense", "that is how it is usually done", "the frontend will need it" are not anchors; such things go to a separate "no anchor" section.
5. **Rule of dates** — a later written decision overrides an earlier one. Every anchor is checked for being overridden. A "Discuss" label on a ticket may be stale.
6. **Answer format** — flat list / table / whatever is needed as output, plus the mandatory sections "what was rejected and why" and "objections to opponents".

## Step 3. Three roles, mutually exclusive hypotheses

Launch **all three in one message** so they run in parallel. Model — `sonnet`. In each role's prompt: its hypothesis + the other two hypotheses verbatim + the requirement to refute them.

The working triplet for "how many of what is needed" questions:

- **Minimalist** — "almost nothing is needed, the rest fits into what exists". Attacks every candidate: covered by a field, covered by an enum, fits an existing path, forbidden verbatim.
- **Maximalist** — "the list is undercounted, there are requirements with no owner at all". Counts from the product requirements, not from the list of tickets already filed.
- **Boundary auditor** — "the debate is pointless until the written is separated from the inferred". Defends neither the large nor the small number: collects all candidates, looks for a verbatim anchor for each and checks for overrides.

For other shapes of question build the poles the same way: two incompatible substantive positions plus a third role that judges not the content but the quality of the evidence.

In every prompt, always: **"The hypothesis is a direction of attack, not a licence to lie. If an anchor directly requires the opposite — admit it and include it."** Without this line the role starts bending facts to its side.

Each role writes its report to its own file (`r1-<role>.md`) and returns it as text.

## Step 4. Convergence, not rounds

Lay the conclusions out by item and split them:

- **agreed** — all three agree (or two agree and the third conceded with acknowledgement) → closed, **never** goes to round 2;
- **disagreed** — there is a live contradiction with anchors on both sides → goes to round 2.

If zero items disagreed, there is no second round. That is how most tasks end.

## Step 5. Round 2 — one agent per contested item

Do not relaunch the whole debate. For each contested item — a separate agent, and in its prompt:

1. the question itself, reduced to "yes/no" or to a choice among the listed options;
2. **all round 1 positions verbatim, with their anchors** — including the one you consider right;
3. **the deciding check, named explicitly.** This is the main thing. Round 2 is won not by re-reading but by a concrete action: read the contested thread in full (both sides usually quote the same phrase in their favour), check the permissions/scope of an existing mechanism, find a precedent in the same repository, check the third option nobody covered in round 1;
4. the requirement to name what exactly each opponent misread.

### The fourth voice — Codex

Three roles are one model with the same blind spots, and disagreement between them can be staged. In round 2 add a different model, but only on items whose deciding check lies in the code: Codex sees the file system and does not see the tracker, the design tool or the threads. Hand it the needed materials as paths to scratchpad files.

```bash
codex exec -s read-only -c sandbox_mode="read-only" -o "$SCRATCH/codex-<item>.md" \
  "Question: <question reduced to yes/no>. Positions with their anchors: <round 1 positions verbatim>. Decide which one is right by checking the repo yourself: name the file:line or the quote that settles it, and say what each position misread. No praise, no style nits. Read as needed, modify nothing." \
  < /dev/null 2>"$SCRATCH/codex-<item>.err" >/dev/null
```

Do not pin the model — it comes from the config; `< /dev/null` is mandatory, otherwise it hangs on stdin; tool timeout `600000`. Empty output means the run failed (auth, model, arguments), the reason is in the tail of `.err`: show it to the user, do not retry blindly.

A voice, not an arbiter. Codex's output passes the same anchor rule as the roles: agrees with them — the item is closed; disagrees with a verbatim anchor — the item stays contested; disagrees without an anchor — goes to "no anchor", not to the conclusion.

Then step 4 again. Round 3 is rare and only on items where round 2 did not converge.

## Step 6. The synthesis is yours, not the agents'

You write the final artifact. The agents' reports are raw material, they stay in the scratchpad and not a paragraph of them makes it into the result. Every conclusion lives **in one place**, without overlapping sections.

## Step 7. The file holds only the answer

The most important rule of the skill, and the one broken most often.

The artifact file carries **data in the requested form and nothing else**. Asked for a flat list — the file holds the list lines. Everything that explains, evaluates or justifies goes **into the chat reply**.

The file does **not** get:

- verdicts and conclusions of the debate, "confirmed / refuted", which role was right;
- justifications and anchor quotes, the "what was rejected and why" sections;
- statuses and estimates — "written", "decided", "fork", "at least 2, at most 9";
- a preamble about sources, run dates, the number of comments read;
- notes that an item is conditional — name the condition in the chat.

Before writing, go through the file line by line and ask on every line: **is this data or explanation?** Cut the explanation into the chat. The temptation to "add context so the file is self-contained" is exactly the layer you were asked not to put in. The rule is stronger than the wish to make the artifact understandable without you.

Into the chat, mandatory: open forks with their owner, blockers, conditional items, and what exactly closed the debate — briefly, by item, without retelling the reports.

## What not to do

- Do not ask the roles "is the plan good" — the question is generative, it has no zero, objections will keep appearing forever. Ask about the next action.
- Do not add a fourth "collector" role: retelling raw data loses verbatimness.
- Do not run a round on items already agreed, for the sake of symmetry.
- Do not take an agent's conclusion on faith if it rests on a quote you have not seen in full: most often the contested phrase, read whole, says something other than what was derived from it.

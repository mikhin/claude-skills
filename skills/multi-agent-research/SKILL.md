---
name: multi-agent-research
description: Spawn multiple parallel sub-agents to investigate, research, analyze, and critique a topic in depth. Use this skill whenever the user wants deep research, multi-perspective analysis, investigation, or critical examination of any topic. Triggers on phrases like "research this", "investigate", "deep dive", "analyze from multiple angles", "multi-agent research", "critique this idea", "explore this topic", or any request that would benefit from parallel research agents examining a subject from different perspectives. Even casual requests like "what do you think about X from all angles" or "give me a thorough breakdown of Y" should trigger this skill.
---

# Multi-Agent Research

This skill spawns **4 parallel sub-agents**, each with a distinct role, to deeply research a user-provided topic. Results are synthesized into a final comprehensive report.

## Step 1: Always Ask for the Topic First

**Before doing anything else**, ask the user:

> What topic would you like me to research with multiple agents? Please describe it in as much detail as you'd like — the more context, the better the results.

Do NOT proceed until the user provides a topic. Even if they already mentioned something, confirm it explicitly.

## Step 2: Spawn 4 Sub-Agents in Parallel

Once you have the topic, launch **all 4 agents simultaneously** using subagents. Each agent gets a focused prompt with its role and the user's topic.

### Agent Roles

**1. Investigator**
- Mission: Find facts, evidence, sources, data points, historical context
- Output: A factual briefing with key findings, sourced where possible
- Prompt emphasis: "You are a thorough investigator. Find concrete facts, evidence, examples, case studies, and historical precedents about: {TOPIC}. Be specific. Cite sources when possible. Write your findings as a structured briefing."

**2. Analyst**
- Mission: Identify trends, patterns, implications, cause-effect relationships
- Output: An analytical report with frameworks, comparisons, and projections
- Prompt emphasis: "You are a strategic analyst. Analyze trends, patterns, market dynamics, cause-effect chains, and future implications of: {TOPIC}. Use frameworks where helpful. Compare alternatives. Quantify where possible. Write your analysis as a structured report."

**3. Critic**
- Mission: Find flaws, risks, weaknesses, counterarguments, failure modes
- Output: A critical assessment highlighting what could go wrong
- Prompt emphasis: "You are a rigorous critic. Find flaws, risks, weaknesses, counterarguments, blind spots, and failure modes related to: {TOPIC}. Challenge assumptions. Identify what's being overlooked. Be constructively harsh. Write your critique as a structured assessment."

**4. Devil's Advocate**
- Mission: Challenge the prevailing narrative, argue the opposing side, question consensus
- Output: A contrarian briefing that stress-tests conventional wisdom
- Prompt emphasis: "You are a devil's advocate. Take the opposing or unconventional position on: {TOPIC}. Challenge the mainstream view. Argue what most people get wrong. Present the strongest case for the minority/contrarian position. Write your contrarian briefing as a structured argument."

### Sub-Agent Spawn Pattern

```bash
# Launch all 4 in parallel using subagents
# Each agent should write its output to a separate file:
#   /tmp/research/{topic-slug}/investigator.md
#   /tmp/research/{topic-slug}/analyst.md
#   /tmp/research/{topic-slug}/critic.md
#   /tmp/research/{topic-slug}/devils-advocate.md
```

Each agent should:
- Use web search if available and relevant
- Write 300-800 words
- Structure output with clear headers
- Stay focused on its specific role — no overlap

## Step 3: Synthesize

After all 4 agents complete, read all 4 outputs and produce a **synthesis report**.

**Critical rule: each finding appears in exactly one place.** Never repeat the same issue across multiple sections.

Structure (mandatory):

1. **Executive summary** — 2-3 sentences, the overall verdict
2. **Findings** — one flat table. Columns: finding, severity/type, source agent(s), action. Each finding = one row. No finding appears twice. No separate "risks", "recommendations", "next steps" sections — the action column covers that.

Do NOT create multiple overlapping sections (e.g. "bugs" + "risks" + "recommendations" that restate the same items). All findings go into the single table.

Write the synthesis to `/tmp/research/{topic-slug}/synthesis.md`.

## Step 4: Present to User

Show the user:
1. The synthesis report (in full)
2. A brief summary of what each agent found (1-2 sentences each)
3. Offer to show any individual agent's full output on request

## Notes

- If subagents are not available (e.g. in Claude.ai), run the 4 roles sequentially instead — same prompts, same structure, just one at a time.
- The topic can be anything: a business idea, technology, policy, strategy, concept, person, event, trend, etc.
- Encourage the user to provide context about *why* they're researching — it helps agents focus.

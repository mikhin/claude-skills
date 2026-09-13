# consensus — adversarial multi-agent debate for Claude Code

A [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skill for questions where the sources disagree and a missed item costs more than a second look: how many endpoints a feature needs, what is in scope, which of two readings of a spec is right, what was actually decided versus what only looks decided.

Not a research fan-out. The roles get mutually exclusive hypotheses and must refute each other. The session (Opus) is the judge over Sonnet agents; the debate ends on agreement, not after a fixed number of rounds.

## How it works

1. **Ground first.** The judge collects the sources itself: documents, tickets, and their comment threads. Big MCP responses go to files; agents get paths, not the job of re-fetching.
2. **One brief.** A `BRIEF.md` with the question, the unit of answer, facts already verified, every source by id, and the rule of evidence: an anchor is a verbatim quote with author, date and location. A later written decision overrides an earlier one.
3. **Three roles, one message, in parallel.** Minimalist ("almost nothing is needed"), Maximalist ("the list is short, some requirements have no owner"), Boundary auditor ("separate what is written from what is inferred"). Each prompt includes the other two hypotheses and the line: a hypothesis is a direction of attack, not a licence to lie.
4. **Convergence.** Items where all agree are closed and never reopened. Only live contradictions with anchors on both sides go to round 2.
5. **Round 2, one agent per open item.** The prompt names the deciding check: read the whole thread, verify the scope of an existing mechanism, find a precedent, test the third option nobody covered. For items decided in code, a fourth voice from another model via [Codex CLI](https://github.com/openai/codex).
6. **Synthesis by the judge.** Agent reports stay in the scratchpad. The output file carries only the answer in the requested shape; verdicts, anchors and open forks go to the chat.

## Installation

```bash
claude skill add mikhin/claude-consensus
```

Or copy `SKILL.md` to `~/.claude/skills/consensus/SKILL.md`.

## Usage

```
/consensus
```

Or ask: "let the agents argue", "debate until consensus", "check from several sides".

## Requirements

- Claude Code CLI with sub-agents
- Optional: [Codex CLI](https://github.com/openai/codex) for the fourth voice in round 2

## License

MIT

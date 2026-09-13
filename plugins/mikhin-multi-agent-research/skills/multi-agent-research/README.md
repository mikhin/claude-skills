# Multi-Agent Research

A [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skill that spawns 4 parallel sub-agents to research any topic from multiple perspectives, then synthesizes findings into a comprehensive report.

## How It Works

When triggered, the skill launches 4 specialized agents simultaneously:

| Agent | Role |
|---|---|
| **Investigator** | Facts, evidence, sources, historical context |
| **Analyst** | Trends, patterns, frameworks, projections |
| **Critic** | Flaws, risks, weaknesses, failure modes |
| **Devil's Advocate** | Contrarian views, challenges to consensus |

Each agent writes 300-800 words. After all complete, the skill synthesizes everything into a final report highlighting agreements, tensions, risks, and recommended next steps.

## Installation

```bash
claude skill add mikhin/claude-multi-agent-research
```

Or manually copy `SKILL.md` to `~/.claude/skills/multi-agent-research/SKILL.md`.

## Usage

In Claude Code, use the slash command:

```
/multi-agent-research
```

Or just ask naturally — the skill triggers on phrases like:
- "research this"
- "deep dive into X"
- "analyze from multiple angles"
- "investigate X"
- "give me a thorough breakdown of Y"

## Example

```
> /multi-agent-research

What topic would you like me to research?

> Should our startup switch from REST to GraphQL for our public API?

[4 agents spawn in parallel...]
[Synthesis report generated]
```

## Output

The skill produces:
- 4 individual agent reports saved to `/tmp/research/{topic}/`
- A synthesis report with:
  - Executive summary
  - Key agreements across agents
  - Key tensions and disagreements
  - Top risks and blind spots
  - Recommended next steps

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI
- A Claude model that supports sub-agents (Opus, Sonnet)

## License

MIT

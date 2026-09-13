# cx — Codex review for Claude Code

A [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skill that gets a second opinion from a different model. Claude hands the diff to [OpenAI Codex CLI](https://github.com/openai/codex), Codex reads and reports, Claude judges every finding against the code and only then edits.

One or two rounds. Codex never writes.

## What it reviews

| Argument | Target |
|---|---|
| none / `base=<branch>` / PR URL | branch diff against its base |
| `wt` | working tree, including untracked files |
| `commit=<sha>` | one commit |
| `spec=<file>` | any of the above, checked against a plan |
| `plan=<file>` | the plan itself, no diff |

## Flow

1. Shows the Codex model from `~/.codex/config.toml` before spending quota.
2. Runs `codex exec` read-only, output to a scratch file.
3. Claude answers each finding in one line: accepted, or rejected with an anchor (code, test, contract). "Seems fine" is not an anchor.
4. Waits for your go, then applies the accepted ones.
5. Round 2 only if something changed: Codex gets its own list back and says what is fixed, what is not, and what the fixes broke. There is no round 3.

## Installation

```bash
claude skill add mikhin/claude-cx
```

Or copy `SKILL.md` to `~/.claude/skills/cx/SKILL.md`.

## Requirements

- Claude Code CLI
- [Codex CLI](https://github.com/openai/codex) signed in, with a model set in `~/.codex/config.toml`

## Usage

```
/cx
/cx wt
/cx commit=abc123
/cx plan=plan.txt
```

Or ask: "codex review", "let codex look at this".

## License

MIT

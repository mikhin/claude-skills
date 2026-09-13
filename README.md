# claude-skills

My Claude Code skills, in one repo.

| Skill | What it does |
| --- | --- |
| [`cx`](skills/cx) | Cross-model review of a diff, commit or plan through the Codex CLI. Codex reads, Claude judges. |
| [`consensus`](skills/consensus) | Adversarial multi-agent debate: roles get mutually exclusive hypotheses and must refute each other, exit on agreement. |
| [`multi-agent-research`](skills/multi-agent-research) | Four parallel sub-agents research a topic from different angles, one synthesised report. |
| [`all-check`](skills/all-check) | Run every check the project has except e2e, scoped to the files of the current PR, and report one line per check. |
| [`yuri-decisions`](skills/yuri-decisions) | How I decide: answer the why, look it up before inventing it, fix the class not the call site. |
| [`yuri-review`](skills/yuri-review) | How I want bugs and findings handled: why didn't the tests catch it, failing test before fix, anchored findings, per-item verdicts. |
| [`yuri-comms`](skills/yuri-comms) | How I write to people: draft first, no blame, no hinted defects, one question instead of a pile of comments. |
| [`yuri-stack`](skills/yuri-stack) | What I already know and how work gets verified: the checking stack, viewport review, the product side of my own plugins and bots. |

The `yuri-*` four were extracted from ~1.4 GB of my own Claude Code session logs — the corrections I actually make, not aspirations.

## Install

```sh
git clone https://github.com/mikhin/claude-skills.git ~/Code/claude-skills
ln -sfn ~/Code/claude-skills/skills/* ~/.claude/skills/
```

## Always-on skills

`yuri-decisions` and `yuri-stack` describe constants, so they are useless behind a trigger. A `SessionStart` hook prints them into every session instead. In `~/.claude/settings.json`:

```json
{ "hooks": { "SessionStart": [ { "matcher": "", "hooks": [
  { "type": "command", "command": "~/Code/claude-skills/hooks/autoload.sh" }
] } ] } }
```

Costs ~1.6k tokens per session. Pick a different set with `AUTOLOAD_SKILLS="a b"`.

## License

MIT

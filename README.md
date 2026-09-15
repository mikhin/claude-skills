# claude-skills

My Claude Code skills, in one plugin.

| Skill | What it does |
| --- | --- |
| [`cx`](skills/cx) | Cross-model review of a diff, commit or plan through the Codex CLI. Codex reads, Claude judges. |
| [`consensus`](skills/consensus) | Adversarial multi-agent debate: roles get mutually exclusive hypotheses and must refute each other, exit on agreement. |
| [`multi-agent-research`](skills/multi-agent-research) | Four parallel sub-agents research a topic from different angles, one synthesised report. |
| [`all-check`](skills/all-check) | Run every check the project has except e2e, scoped to the files of the current PR, and report one line per check. |
| [`decisions`](skills/decisions) | How I decide: answer the why, look it up before inventing it, fix the class not the call site. |
| [`review`](skills/review) | How I want bugs and findings handled: why didn't the tests catch it, failing test before fix, anchored findings, per-item verdicts. |
| [`comms`](skills/comms) | How I write to people: draft first, no blame, no hinted defects, one question instead of a pile of comments. |
| [`stack`](skills/stack) | What I already know and how work gets verified: the checking stack, viewport review, the product side of my own plugins and bots. |

`decisions`, `review`, `comms` and `stack` were extracted from ~1.4 GB of my own Claude Code session logs — the corrections I actually make, not aspirations.

## Install

```
/plugin marketplace add mikhin/claude-skills
/plugin install mikhin@claude-skills
```

Skills then show up namespaced: `mikhin:cx`, `mikhin:review`, `mikhin:all-check`.

## Always-on skills

`decisions` and `stack` describe constants, so they are useless behind a trigger. The
plugin ships a `SessionStart` hook that prints them into every session instead.
Pick a different set with `AUTOLOAD_SKILLS="a b"`.

## License

MIT

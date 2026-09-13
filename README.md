# claude-skills

My Claude Code skills. One repo, but each skill installs on its own.

```sh
/plugin marketplace add mikhin/claude-skills
```

Then pick what you want:

| Install | Skill | What it does |
| --- | --- | --- |
| `/plugin install mikhin-cx@claude-skills` | `mikhin-cx:cx` | Cross-model review of a diff, commit or plan through the Codex CLI. Codex reads, Claude judges. |
| `/plugin install mikhin-consensus@claude-skills` | `mikhin-consensus:consensus` | Adversarial multi-agent debate: roles get mutually exclusive hypotheses and must refute each other, exit on agreement. |
| `/plugin install mikhin-multi-agent-research@claude-skills` | `mikhin-multi-agent-research:multi-agent-research` | Four parallel sub-agents research a topic from different angles, one synthesised report. |
| `/plugin install mikhin-all-check@claude-skills` | `mikhin-all-check:all-check` | Run every check the project has except e2e, scoped to the files of the current PR, one line per check. |
| `/plugin install mikhin-review@claude-skills` | `mikhin-review:review` | How I want bugs and findings handled: why didn't the tests catch it, failing test before fix, anchored findings, per-item verdicts. |
| `/plugin install mikhin-comms@claude-skills` | `mikhin-comms:comms` | How I write to people: draft first, no blame, no hinted defects, one question instead of a pile of comments. |
| `/plugin install mikhin-decisions@claude-skills` | `mikhin-decisions:decisions` | How I decide: answer the why, look it up before inventing it, fix the class not the call site. **Autoloads.** |
| `/plugin install mikhin-stack@claude-skills` | `mikhin-stack:stack` | What I already know and how work gets verified: the checking stack, viewport review, the product side of my own plugins and bots. **Autoloads.** |

`decisions`, `review`, `comms` and `stack` were extracted from ~1.4 GB of my own Claude Code session
logs — the corrections I actually make, not aspirations.

## The two that autoload

`decisions` and `stack` describe constants, so they are useless behind a trigger. Those two ship a
`SessionStart` hook that prints the skill into every session instead, about 800 tokens each. Install
them only if you want that cost on every session; the other six stay dormant until triggered.

## License

MIT

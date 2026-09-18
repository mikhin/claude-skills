# claude-skills

My personal Claude Code skills, in one plugin. The general-purpose ones (`cx`, `consensus`, `multi-agent-research`) live in [mikhin/agent-skills](https://github.com/mikhin/agent-skills).

| Skill | What it does |
| --- | --- |
| [`all-check`](skills/all-check) | Run every check the project has except e2e, scoped to the files of the current PR, and report one line per check. |
| [`decisions`](skills/decisions) | How I decide: answer the why, look it up before inventing it, fix the class not the call site. |
| [`review`](skills/review) | `/review`: runs the built-in code-review at medium, judges every finding against the code, ends with a merge verdict. Plus how I want bugs handled: why didn't the tests catch it, failing test before fix, two rounds and stop. |
| [`comms`](skills/comms) | How I write to people: draft first, no blame, no hinted defects, one question instead of a pile of comments. |
| [`stack`](skills/stack) | What I already know and how work gets verified: the checking stack, viewport review, the product side of my own plugins and bots. |

`decisions`, `review`, `comms` and `stack` were extracted from ~1.4 GB of my own Claude Code session logs — the corrections I actually make, not aspirations.

## Install

```
/plugin marketplace add mikhin/claude-skills
/plugin install mikhin@claude-skills
```

Skills then show up namespaced: `mikhin:review`, `mikhin:all-check`.

## Always-on skills

`decisions` and `stack` describe constants, so they are useless behind a trigger. The
plugin ships a `SessionStart` hook that prints them into every session instead.
Pick a different set with `AUTOLOAD_SKILLS="a b"`.

## License

MIT

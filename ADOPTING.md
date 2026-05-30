# Adopting BRAINFRAME skills in any CLI AI

Every skill in this collection is a **plain-Markdown `SKILL.md`** — frontmatter (name +
description) followed by a body of instructions. That makes them portable across agents,
even ones that don't speak Anthropic's Agent Skills spec.

## Claude Code (native)

Skills install to `~/.claude/skills/<name>/SKILL.md` and are picked up automatically. The
`description` frontmatter is what the model matches against to decide when to invoke a skill,
so it's written to trigger on natural phrasing ("status", "checkpoint", "compress").

```bash
# whole bundle
curl -fsSL https://raw.githubusercontent.com/The9thRealm/brainframe-skills/main/install.sh | bash
# or a subset
curl -fsSL https://raw.githubusercontent.com/The9thRealm/brainframe-skills/main/install.sh | bash -s -- qpulse handoff
```

Install into a project-local skills dir instead of the global one:

```bash
SKILLS_DIR=./.claude/skills curl -fsSL .../install.sh | bash
```

## Other CLI agents (Cursor, Aider, Gemini CLI, Codex, custom harnesses)

These don't auto-load `~/.claude/skills`, but the content is still directly usable:

1. **As a rules / system-prompt fragment.** Copy the body of a `SKILL.md` (everything below
   the frontmatter) into your agent's rules file or system prompt. The steps and format are
   tool-agnostic; only the host-specific call (e.g. "the task-list tool") differs — adapt
   that one line to your agent.
2. **As an on-demand reference.** Keep the `SKILL.md` files in your repo (e.g.
   `docs/skills/`) and tell your agent: "follow `docs/skills/qpulse/SKILL.md` when I ask for
   status." Many CLIs will read and apply it on request.
3. **As a `@`-mentionable file.** In agents that support file references, point at the
   `SKILL.md` directly.

## What each skill needs from the host

| Skill | Host capability it uses | If your agent lacks it |
|-------|--------------------------|------------------------|
| `qpulse` | run read-only shell checks; read a task file | drop the SERVICES section; keep the format |
| `handoff` | write a file; (optionally) `git status` | write the checkpoint manually to any note file |
| `context-compress` | self-awareness of context use; search tools | apply the habits; trigger manually with "compress" |

None require network access, credentials, or a specific backend. They're behavioral skills,
not services.

## Versioning & updates

Each skill carries a `VERSION` (semver). The bundle's `manifest.json` pins the current set;
`update.sh` diffs installed versions against it and re-installs only what changed.

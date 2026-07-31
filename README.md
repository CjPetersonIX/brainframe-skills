# BRAINFRAME SKILLS

```
██████╗ ██████╗  █████╗ ██╗███╗   ██╗███████╗██████╗  █████╗ ███╗   ███╗███████╗
██╔══██╗██╔══██╗██╔══██╗██║████╗  ██║██╔════╝██╔══██╗██╔══██╗████╗ ████║██╔════╝
██████╔╝██████╔╝███████║██║██╔██╗ ██║█████╗  ██████╔╝███████║██╔████╔██║█████╗
██╔══██╗██╔══██╗██╔══██║██║██║╚██╗██║██╔══╝  ██╔══██╗██╔══██║██║╚██╔╝██║██╔══╝
██████╔╝██║  ██║██║  ██║██║██║ ╚████║██║     ██║  ██║██║  ██║██║ ╚═╝ ██║███████╗
╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝
                    S K I L L S   ·   B U N D L E
```

Portable agent skills any CLI AI can adopt. Each skill is a plain-Markdown `SKILL.md` that
lives in **its own repo**; this is the **bundle** that ties them together for one-shot
install and package-manager-style upgrade packs.

## Install everything (one line)

```bash
curl -fsSL https://raw.githubusercontent.com/CjPetersonIX/brainframe-skills/main/install.sh | bash
```

Install a subset:

```bash
curl -fsSL https://raw.githubusercontent.com/CjPetersonIX/brainframe-skills/main/install.sh | bash -s -- qpulse handoff
```

Upgrade later (diffs installed versions against the manifest, applies only what changed):

```bash
curl -fsSL https://raw.githubusercontent.com/CjPetersonIX/brainframe-skills/main/update.sh | bash
```

All install to `~/.claude/skills/` by default — override with `SKILLS_DIR=...`.

## The skills

| Skill | Repo | What it does |
|-------|------|--------------|
| **qpulse** | [brainframe-qpulse](https://github.com/CjPetersonIX/brainframe-qpulse) | Read-only status dashboard — in-progress / queued / blocked / services. |
| **handoff** | [brainframe-handoff](https://github.com/CjPetersonIX/brainframe-handoff) | Structured `CKPT` checkpoint so the next session resumes cold. |
| **context-compress** | [brainframe-context-compress](https://github.com/CjPetersonIX/brainframe-context-compress) | Proactively shrink working context before it overflows. |

Each is independently installable from its own repo; the bundle just installs/updates them
together. New skills are added to [`manifest.json`](manifest.json) as they ship.

## Two layers, on purpose

- **Per-tool repos** — each skill stands alone, with its own README, version, and issues.
  Install just the one you want.
- **This bundle** — a `manifest.json` + `install.sh` + `update.sh` that treat the skills as
  a set, so you can adopt all of them and keep them current with a single command, the way a
  package manager ships update packs.

## Adopting in non-Claude CLIs

See [`ADOPTING.md`](ADOPTING.md) — the `SKILL.md` bodies drop into any agent's rules or
system prompt; they're behavioral skills, not services (no backend, network, or credentials).

## License

Public reference skills. Adopt freely; supply your own config.

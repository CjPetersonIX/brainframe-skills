# BrainFrame skills bundle

Portable `SKILL.md` files for any CLI. **Not BrainFrame OS. Not Helix.**


## Relation to BrainFrame OS (first glance)

1. **This repo is NOT the fleet OS.** Portable `SKILL.md` bundle only.
2. **Fleet live truth** = [BrainframeOS README](https://github.com/CjPetersonIX/BrainframeOS/blob/main/README.md) + [`docs/ops/2026-09-23_t786u_FIRST_GLANCE_CURRENT_STATE.md`](https://github.com/CjPetersonIX/BrainframeOS/blob/main/docs/ops/2026-09-23_t786u_FIRST_GLANCE_CURRENT_STATE.md).
3. **CKPT format:** `<NODE-ID> CKPT <MASTER>.<LOCAL>` · current fleet epoch tip **5291 OPEN** (5292 VOID).
4. **MasterQ / map / rules:** MasterQ [`comms/Q-PULSE.md`](https://github.com/CjPetersonIX/BrainframeOS/blob/main/comms/Q-PULSE.md) · map [`BRAINFRAME_MAP.md`](https://github.com/CjPetersonIX/BrainframeOS/blob/main/BRAINFRAME_MAP.md) · rules on BrainframeOS README.

---

Brains install from the wrappers:

- [LITE wrapper](https://github.com/CjPetersonIX/Brainframe-litebrain-wrapper) — under 8 GB
- [FULL wrapper](https://github.com/CjPetersonIX/Brainframe-fullbrain-wrapper) — 8 GB+

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/CjPetersonIX/brainframe-skills/main/install.sh | bash
```

Subset: `bash -s -- qpulse handoff`

Upgrade: `curl -fsSL https://raw.githubusercontent.com/CjPetersonIX/brainframe-skills/main/update.sh | bash`

Default dir: `~/.claude/skills/` (`SKILLS_DIR=` to override).

## Skills

| Skill | Repo | Notes |
|---|---|---|
| qpulse | [brainframe-qpulse](https://github.com/CjPetersonIX/brainframe-qpulse) | `1.1.0` · `<NODE-ID> CKPT <MASTER>.<LOCAL>` |
| handoff | [brainframe-handoff](https://github.com/CjPetersonIX/brainframe-handoff) | `1.1.0` · same stamp, millidigit is a counter |
| context-compress | [brainframe-context-compress](https://github.com/CjPetersonIX/brainframe-context-compress) | lean context on small RAM |

Connector **master skills** (Figma, GitHub, Gmail, …) are separate repos. They teach one vendor connector. They are not this OS and not this bundle.

CKPT rules: one millidigit per brain, not per VP. State on `main`.

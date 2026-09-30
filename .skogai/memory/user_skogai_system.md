---
name: user-skogai-system
description: Emil runs a personal routing-based config framework (skogai) that chains SKOGAI.md files across dotfiles and projects
metadata:
  node_type: memory
  type: user
  originSessionId: a0de7484-11ea-413f-8d5b-d16b69d73052
  modified: 2026-09-30T09:46:25.367Z
---

Emil (emil@skogsund.se) maintains a personal infrastructure layer called "skogai": a set of `SKOGAI.md` router files that chain together across `~/skogai`, `~/.config/skogai`, and per-project `CLAUDE.md` files (each pointing further via `<routes>` blocks, e.g. `@.skogai`). This project's `.skogai/memory/` directory is part of that framework — it's where Claude Code's auto memory is meant to live.

Emil is comfortable with config/infra work and verifies system behavior directly (e.g. asking to confirm auto memory "actually worked" rather than taking it on faith).

**How to apply:** treat skogai-related paths and routing conventions as intentional infrastructure, not clutter — don't "clean up" or flatten router files without asking. See [[reference-skogai-config-routes]].

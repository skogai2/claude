---
name: reference-skogai-config-routes
description: "Where skogai's routing config lives — three chained SKOGAI.md index files plus this project's CLAUDE.md router"
metadata:
  node_type: memory
  type: reference
  originSessionId: a0de7484-11ea-413f-8d5b-d16b69d73052
  modified: 2026-09-30T09:49:15.980Z
---

Skogai's config/routing is spread across:
- `~/skogai/SKOGAI.md` — the human-facing front door/index (currently has TODO stubs: dot-skogai, dash-skogai, skogix, claude)
- `~/.config/skogai/SKOGAI.md` — `$XDG_SKOGAI_DIR` config index (env vars, general layout, mappings — some entries still TODO)
- `~/.config/skogai/mappings.md` — router (not leaf content) for keyboard mapping conventions, one file per tool
- `~/.config/skogai/window-manager.md` — the actual WM keybinding scheme (i3-style, hjkl focus/move) plus per-machine implementation notes (currently: Hyprland/Omarchy at `~/.config/hypr/bindings.lua`); `tmux.md`/`nvim.md` are still TODO stubs in `mappings.md`
- `~/claude/CLAUDE.md` — this project's router, points to `.skogai` locally, which contains `memory/` and `messages/`

**How to apply:** when Emil references "skogai" config, env vars, keybindings, or layout questions, check these router files first rather than searching broadly — they're the intended entry points, even where individual sections are still TODO placeholders. See [[feedback_no_external_source_of_truth]] before treating any dotfiles file as authoritative over these docs.

---
name: feedback-no-external-source-of-truth
description: "Skogai reference docs (e.g. window-manager.md) should reflect what was agreed in conversation, not point at an external dotfiles file as source of truth"
metadata:
  node_type: memory
  type: feedback
  originSessionId: e6685e0e-6be0-466d-95fb-67745774323d
  modified: 2026-09-30T09:49:23.289Z
---

When writing skogai reference docs (e.g. [[reference_skogai_config_routes]]'s `window-manager.md`), don't cite an external config file (like `~/.local/src/.dotfiles/config/i3/config`) as the "source of truth" for the content. Emil corrected this explicitly after an initial draft of `window-manager.md` linked back to the i3 dotfiles as authoritative.

**Why:** these docs are meant to capture what Emil and Claude have actually agreed on through conversation, which may diverge from any one machine's dotfiles over time (multiple machines/WMs, evolving preferences). Treating a dotfiles path as the source of truth would mean the doc silently goes stale or wrong whenever that file changes for unrelated reasons.

**How to apply:** write these docs as standalone, living records — update them directly when a new agreement is reached in conversation, rather than re-deriving content from or linking to an external config as authoritative. If a machine's actual config drifts from the doc, that's a prompt to reconcile in conversation, not to defer to the dotfiles.

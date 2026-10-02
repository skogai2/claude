---
name: gptme-util-memory-link
description: "gptme-util memory CLI is now linked to .skogai/memory via a memory/ symlink"
metadata:
  type: project
---

`gptme-util memory` (gptme core, in `gptme/memory/`) is a separate cross-harness
memory CLI from the `gptme-cc-memory` contrib package already wired into the
UserPromptSubmit/Stop hooks ([[project_cc_memory_hooks_wired]]). It resolves
layered roots (explicit > project > cc > agent > user) and its "project" root
convention is literally `<git-root>/memory/` — it did not see `.skogai/memory`
on its own.

**Why:** Both tools already share the exact same file schema (YAML frontmatter
with `name`/`description`/`metadata.type`, by design — the schema docstring
says "Claude Code compatible"), so no migration was needed, only discovery.

**How to apply:** Created `~/claude/memory` as a symlink to `.skogai/memory`
(`ln -s .skogai/memory memory`). Since `get_workspace()` auto-detects the git
root, this makes `.skogai/memory` the resolved "project" root — and therefore
the default write root — for any `gptme-util memory ...` command run from
anywhere inside this repo, with no env vars needed. Verified: `roots`, `list`,
`search`, `audit`, and `save` (this entry) all operate on the real files.

Useful commands now available: `gptme-util memory recall "<query>"` (relevance
search across layers, supports `--format hook-json` for hook-style output),
`search <pattern>`, `supersede OLD NEW` (replaces manually editing
`superseded_by` frontmatter), `index --write` (regenerate MEMORY.md from
entries — currently shows drift vs. the hand-curated one, which is expected
and harmless since index never auto-overwrites).

`audit` correctly flags `pending-updates.md` and `pending-session-context.md`
as non-entries (no frontmatter) — those are gptme-cc-memory's own scratch
files, not memory entries, so this is not a bug.

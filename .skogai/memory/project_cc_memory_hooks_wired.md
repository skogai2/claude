---
name: project-cc-memory-hooks-wired
description: gptme-cc-memory UserPromptSubmit/Stop hooks are live globally; a real transcript-parsing bug in its extractor was fixed to make this possible
metadata:
  node_type: memory
  type: project
  originSessionId: 28e156c9-b460-414d-9f5a-2efa465dcfd5
  modified: 2026-10-01T23:31:46.727Z
---

As of 2026-10-02, the `gptme-cc-memory` package (source:
`~/claude/gptme-contrib/packages/gptme-cc-memory/`, installed via
`uv tool install`) is wired into **global** `~/.claude/settings.json` as
`UserPromptSubmit` and `Stop` hooks, via wrapper scripts at
`~/.claude/hooks/cc-memory-prompt-submit.sh` and `cc-memory-stop.sh`. It
automates the manual "auto memory" workflow from CLAUDE.md:

- `UserPromptSubmit` → scores this memory directory's files against the
  live prompt and injects the top matches as a `<memory_relevant_entries>`
  block (separate from, and narrower than, loading the whole `MEMORY.md`
  index by hand).
- `Stop` → heuristically extracts corrections/confirmations/session context
  from the ending session's transcript into `memory/pending-updates.md` and
  `memory/pending-session-context.md`, which the next `UserPromptSubmit`
  injects once and clears (pending-updates ages out after 3 days instead).

**Why wrapper scripts exist at all:** `gptme-cc-memory-stop-hook` only reads
a `CC_TRAJECTORY_FILE` env var — it never reads stdin. But Claude Code's
actual `Stop` hook protocol delivers the transcript path via stdin JSON
(`transcript_path` key), not an env var. `cc-memory-stop.sh` bridges this:
reads stdin once, extracts `transcript_path` with `python3 -c` (no `jq`
dependency), exports it as `CC_TRAJECTORY_FILE`, then execs the real tool.

**The bigger bug, now fixed:** the extractor's `read_trajectory()` expected
gptme's own flat trajectory format (`{"role": "human"/"assistant",
"content": "..."}`). Real Claude Code transcripts (`~/.claude/projects/**/*.jsonl`)
look like `{"type": "user"/"assistant", "message": {"role": "user"/"assistant",
"content": "..." | [blocks]}}` — a different shape entirely (`"human"` vs
`"user"`, nested under `"message"`, content sometimes a list of content
blocks). Wiring the Stop hook without fixing this would have been a silent
no-op forever: valid JSON in, zero matches out, no error anywhere. Patched
`_normalize_message()` into `extractor.py` to convert either shape into the
flat form before the existing regex detectors run. All 16 existing tests
still pass; verified live against this session's own transcript (correctly
pulled goal/last-turn/message-count and caught a "perfect!" confirmation).

**How to apply:** If `<memory_relevant_entries>` or "Previous Session
Context" blocks show up unexpectedly in a prompt, that's this pipeline —
not a hallucination or injected content from elsewhere. If memory injection
seems stale or wrong, check `~/claude/.skogai/state/cc-memory/metadata.json`
(injection history/confidence) and `memory/pending-updates.md` before
assuming the static memory files themselves are the problem. If you touch
`gptme-contrib/packages/gptme-cc-memory/src/...` again, the installed CLI
is a **non-editable** `uv tool install` snapshot — changes need
`uv tool install --reinstall ~/claude/gptme-contrib/packages/gptme-cc-memory`
to take effect, they don't apply live.

Related: [[project_agent_homes_architecture]]. A sibling package,
`gptme-coordination` (inter-agent work queue + messaging), was *not* wired
up — tracked instead as a gptodo task in `~/claude/tasks/` for evaluation,
since it's a bigger adoption decision than a hook hookup.

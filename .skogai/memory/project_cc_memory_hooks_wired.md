---
name: project-cc-memory-hooks-wired
description: gptme-cc-memory UserPromptSubmit/Stop hooks are live globally; a real transcript-parsing bug in its extractor was fixed to make this possible
metadata:
  node_type: memory
  type: project
  originSessionId: 28e156c9-b460-414d-9f5a-2efa465dcfd5
  modified: 2026-10-02T15:12:14.822Z
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
assuming the static memory files themselves are the problem.

**Which binary the hooks run (updated 2026-10-02):** both wrappers prefer
`/skogai/bin/gptme-cc-memory-*` (override dir with `SKOGAI_BIN`) and fall back
to the `uv tool install` copy on PATH. The `/skogai/bin` launchers come from
`skogai2/dash-skogai` (PR #1 / `admin/install-tools.sh`) and install from the
fork `skogai2/gptme-contrib`, pinned to a commit SHA (tag `skogai-2026.10.02`,
which carries the extractor fix). Until `install-tools.sh` has run on `/skogai`
the fallback is what actually runs. Launchers build on first call (~12 s,
longer than the 10 s UserPromptSubmit timeout), so warm each once after
installing. Originals of the wrappers were backed up to `/tmp/hooks-backup/`
(not durable). If you change `gptme-cc-memory` source: commit to the fork, tag,
bump `CONTRIB_TAG`/`CONTRIB_REF` in dash-skogai's `scripts/gen-bin.py`, rerun
`install-tools.sh`. A fallback `uv tool install` copy is a **non-editable**
snapshot and needs `uv tool install --reinstall <path>`.

Related: [[project_agent_homes_architecture]]. A sibling package,
`gptme-coordination` (inter-agent work queue + messaging), was *not* wired
up — tracked instead as a gptodo task in `~/claude/tasks/` for evaluation,
since it's a bigger adoption decision than a hook hookup.

---
state: backlog
created: 2026-10-02T15:05:56.017059+00:00
priority: high
task_type: action
assigned_to: bob
tags: ["dash-skogai", "coordination", "testing"]
---

# Test dash-skogai launchers as real agent users (claude, dot)

Context: skogai2/dash-skogai PR #1 (feat/portable-launchers). Review 2026-10-02 found it untested as the agent users (author had no sudo).

## Questions / checks
- [ ] Merge-ready check: run `bash admin/install-tools.sh` in /skogai (replaces the bin/gptme-coordination venv symlink), then `sudo bash admin/test-coordination.sh`.
- [ ] Does `mise -C $ROOT which uv` work for an agent when tools/mise is 755 (read-only to them)? If not the launcher falls back to `uv` on PATH, which agents don't have. Does mise try to write to MISE_DATA_DIR / state?
- [ ] Per-user uv cache under /home/<agent>/.cache: does the first call work and are later calls ~0.1s?
- [ ] First-run behaviour with no network: SHA pin should work offline once cached; confirm for a fresh agent user.

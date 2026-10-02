---
state: backlog
created: 2026-10-01T23:31:20.938228+00:00
priority: medium
task_type: action
assigned_to: bob
tags: ["gptme-addons", "coordination", "skogfences"]
---

# Evaluate gptme-coordination for multi-agent messaging

`gptme-coordination` (installed via uv tool, source likely in gptme-contrib)
provides inter-agent work claims and messaging: work-submit/claim/complete/
abandon/list, inbox/send/announce, fact-publish/query/list, plus a durable
queue (queue-list/stats/ingest/retry/discard).

This looks like the actual missing mechanism for the skogfences multi-agent
architecture described in .skogai/messages/skogix.md and dash-skogai.md —
agents (dot, amy, claude, goose) currently share /skogai via Unix group
permissions but have no structured way to hand off work or send each other
messages. `gptme-coordination` could be that layer.

## To evaluate
- [x] Read `gptme-coordination --help` subcommands in full, and the source/README
      in gptme-contrib (likely `packages/gptme-coordination/`)
- [x] Check what backing store it uses (`--db DB` flag) — sqlite? shared file?
      does it live under /skogai (shared) or per-agent homes?
- [x] Figure out whether it's already wired up anywhere (hooks, cron, systemd)
      or fully dormant like gptme-cc-memory was
- [ ] Decide whether it's worth adopting for real inter-agent handoffs, and
      if so, sketch what a first use case looks like (e.g. claude → dot
      handoff on a shared task)

## Context
Surfaced 2026-10-02 while surveying installed gptme addons (`gptme --help`
"Installed external subcommands" list) for things useful to Claude Code.
Same survey led to patching and wiring up gptme-cc-memory's Stop/
UserPromptSubmit hooks (see project_global_git_hooks_landmine.md-style
memory entry to follow, or check .skogai/memory/ for the writeup).

## Findings (2026-10-02)
- Backing store: SQLite (WAL, busy_timeout 5s). Path = `$COORDINATION_DB`, else
  `$AGENT_WORKSPACE`/git root + `state/coordination/coord.db` (per-home by default).
  Tested with `COORDINATION_DB=/skogai/coordination/coord.db`: works.
- Works: CAS claims (second claimer gets `DENIED — held by X`), claim without prior
  submit, 60 min TTL, targeted + broadcast messages, per-recipient inbox, complete
  only by the holder, announce/status.
- **CLI does not sign messages**: HMAC is library-only and advisory (`verified=False`,
  never rejects). Sender is a free-form string: `send mallory ... --to claude` succeeds.
  So it gives no identity guarantee; real isolation must come from unix perms on the DB.
- Shared DB needs a group-writable dir (`2775` on /skogai/coordination): SQLite WAL
  creates -wal/-shm files that every agent user must be able to write.
- Already used: gptodo `--skip-claimed` reads `state/coordination/coord.db`.
  Worktree push guard (warn mode) exists but is not wired into core.hooksPath.

## Multi-user test (real users dot/claude/skogix, group skogai, 2026-10-02) — PASSED
- Cross-user: claim contention (dot wins, claude DENIED), targeted messages, non-holder
  `work-complete` fails / holder succeeds, human user reads the same DB.
- 40 parallel sends from two users: 40/40 stored, no lock errors.
- **Gotcha**: SQLite creates DB files as 0644 and neither umask nor a default ACL can add
  group-write (ACL mask becomes `r--`) -> "attempt to write a readonly database" for the
  second user. Fix: pre-create `coord.db` as 0664 in a setgid group dir; -wal/-shm
  inherit the main DB's mode.
- Agents cannot use `~/.local/bin` of skogix (home not traversable). Shared install:
  `/skogai/bin/gptme-coordination` -> venv in `/skogai/tools/` on system python
  (snapshot install; reinstall to update).
- Setup scripts (gitignored, in `tmp/`): create-skogai-agents.sh,
  setup-skogai-coordination.sh, test-coordination-multiuser.sh.

## Verdict
Adopt for claims + handoffs at /skogai/coordination/coord.db. Do not rely on sender
identity (unsigned CLI). Remaining: wire push guard (warn mode), pick first real
handoff use case, decide who owns the shared install updates.

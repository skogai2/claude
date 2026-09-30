---
state: backlog
created: 2026-09-30T13:14:56.645642+00:00
priority: low
task_type: action
assigned_to: bob
tags: ["autonomous", "testing"]
---

# Exercise scripts/runs/autonomous/autonomous-run-cc.sh

Runs Claude Code autonomously (`claude -p --dangerously-skip-permissions`)
with a system prompt built from the identity files, gated by
gptme-contrib's quota-gate/session-gate scripts, with lockfile
handling and an auto git-push safety net. Present in the repo since
the claude-minimal merge, never actually run.

Blocked on: ABOUT.md/SOUL.md/etc. still being template placeholders
(see tasks/initial-agent-setup.md) — a real identity should probably
land first, since the system prompt is built straight from those
files.

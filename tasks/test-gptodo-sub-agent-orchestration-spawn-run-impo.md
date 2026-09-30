---
state: backlog
created: 2026-09-30T13:14:51.649513+00:00
priority: medium
task_type: action
assigned_to: bob
tags: ["gptodo", "testing"]
---

# Test gptodo sub-agent orchestration (spawn/run/import/fetch/sync)

Commands present but untested this session, since they have real
side effects (launching a tmux+subprocess, or needing GitHub/Linear
auth):

- `gptodo spawn` / `gptodo run` — launches a gptme or Claude Code
  subprocess in tmux. Supports --backend claude, which is the
  interesting one for this project specifically.
- `gptodo output` / `gptodo kill` — manage a spawned session.
- `gptodo import` / `gptodo fetch` / `gptodo sync` — GitHub/Linear
  issue integration, needs API tokens configured first.

Everything else in gptodo (CRUD/readiness/dependency workflow) was
confirmed working out of the box already.

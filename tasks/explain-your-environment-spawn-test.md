---
assigned_to: bob
completed: '2026-10-02T14:18:40+00:00'
created: 2026-09-30T13:51:42.426891+00:00
priority: low
state: done
tags:
- testing
- gptodo
task_type: action
---

# Explain your environment (spawn test)

Test task for [[test-gptodo-sub-agent-orchestration-spawn-run-impo]] — meant
to be launched with `gptodo spawn <task-id> --backend claude` (background,
tmux) so we can exercise `gptodo output` and `gptodo kill` afterwards.

## Your job, spawned agent

Explain the environment you're running in. Specifically report:

- Where you are: working directory, what repo this is, what you can tell
  about its purpose from files at hand (e.g. TASKS.md, CLAUDE.md/SKOGAI.md
  routing).
- What tools/CLIs you have available and confirmed working.
- What this task file itself looked like (frontmatter fields, how you found
  it) and how you'd mark it done via `gptodo`.

No need to change any files or complete other work — the point is purely to
confirm the spawn -> background run -> output -> kill loop works and that a
freshly spawned agent can actually orient itself here. Write your summary as
your final output.

## Orchestrator checklist (for whoever ran `gptodo spawn` — NOT instructions for the spawned agent above)

- [x] Spawned via `gptodo spawn <this-task-id> --backend claude` (with `--system-prompt-file tasks/templates/sub-agent-system-prompt.md`)
- [x] Output retrieved via `gptodo output <session>` and read
- [x] Session cleaned up via `gptodo kill <session>` (already completed/no tmux session by the time of cleanup)

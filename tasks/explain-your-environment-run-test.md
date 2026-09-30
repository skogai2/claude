---
assigned_to: bob
completed: '2026-09-30T14:46:50+00:00'
created: 2026-09-30T13:51:48.103575+00:00
priority: low
state: done
tags:
- testing
- gptodo
task_type: action
---

# Explain your environment (run test)

Test task for [[test-gptodo-sub-agent-orchestration-spawn-run-impo]] — meant
to be launched with `gptodo run <task-id> --backend claude` (synchronous,
foreground) as the counterpart to
[[explain-your-environment-spawn-test]], which exercises the background
`spawn`/`output`/`kill` path instead.

## Your job, spawned agent

Same brief as the spawn-test task: explain the environment you're running
in. Specifically report:

- Where you are: working directory, what repo this is, what you can tell
  about its purpose from files at hand (e.g. TASKS.md, CLAUDE.md/SKOGAI.md
  routing).
- What tools/CLIs you have available and confirmed working.
- What this task file itself looked like (frontmatter fields, how you found
  it) and how you'd mark it done via `gptodo`.

No need to change any files or complete other work — the point is purely to
confirm `gptodo run` blocks until completion and returns the agent's output
directly to the caller, without needing `output`/`kill`.

## Done when

- [x] Run via `gptodo run <this-task-id> --backend claude` (also confirmed with `--backend gptme`)
- [x] Output appeared directly in the calling session (no separate
      `gptodo output` call needed)

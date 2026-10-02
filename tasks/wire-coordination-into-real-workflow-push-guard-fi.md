---
state: backlog
created: 2026-10-02T15:05:56.713865+00:00
priority: medium
task_type: action
assigned_to: bob
tags: ["dash-skogai", "coordination", "gptodo"]
---

# Wire coordination into real workflow: push guard + first handoff

Follow-ups from task #9 evaluation (evaluate-gptme-coordination-for-multi-agent-messag):
- [ ] Wire gptme-coordination's worktree push guard (post-commit/pre-push, warn mode) into the global core.hooksPath (~/.config/git/hooks).
- [ ] Pick the first real claude -> dot handoff (shared task claim + message) and run it end to end.
- [ ] Confirm gptodo --skip-claimed uses the shared /skogai coordination DB (launchers now default COORDINATION_DB; ~/claude's per-repo state/coordination/coord.db is separate).
- [ ] Decide who owns launcher/install updates when gptme-contrib bumps (tag + CONTRIB_REF SHA, see PR #1).

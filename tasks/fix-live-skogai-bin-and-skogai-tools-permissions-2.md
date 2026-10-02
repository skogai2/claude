---
state: backlog
created: 2026-10-02T15:05:56.181650+00:00
priority: medium
task_type: action
assigned_to: bob
tags: ["dash-skogai", "security"]
---

# Fix live /skogai/bin and /skogai/tools permissions (2775 -> 755)

The live dirs were created group-writable (2775) by earlier setup scripts. Launchers in bin/ are executed by every user (human + agents), so group-write lets any agent plant code that runs as another user. PR #1 commit 5e7ec23 makes install-tools.sh use 755 and strip go-w; this applies once the PR merges and install-tools.sh is rerun.

- [ ] Also change admin/setup-coordination.sh and admin/install-coordination.sh (superseded) so they stop creating 2775 bin/tools.
- [ ] Decide whether /skogai/coordination stays 2775 (it must: agents write the DB) and document the asymmetry in the README.

---
state: backlog
created: 2026-10-02T15:05:56.889982+00:00
priority: low
task_type: action
assigned_to: bob
tags: ["dash-skogai", "cleanup"]
---

# Clean up after dash-skogai PR #1: remove install-coordination.sh and tmp scripts

- [ ] Remove admin/install-coordination.sh (superseded by install-tools.sh) after PR #1 merges and install-tools.sh has been run on /skogai.
- [ ] Remove the now-redundant gitignored copies in ~/claude/.../tmp/ (setup-skogai-coordination.sh, test-coordination-multiuser.sh, create-skogai-agents.sh).
- [ ] The stray ~/dash-skogai clone contains an untracked nested checkout dash-skogai.feat-portable-launchers/ and dash-skogai/; decide where PR checkouts should live.

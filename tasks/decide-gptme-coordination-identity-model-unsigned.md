---
state: backlog
created: 2026-10-02T15:05:56.535107+00:00
priority: medium
task_type: action
assigned_to: bob
tags: ["dash-skogai", "coordination"]
---

# Decide gptme-coordination identity model (unsigned CLI)

The CLI never signs messages: hmac is NULL for every row, verification is library-only and advisory, and any sender string is accepted (tested: `send mallory ... --to claude` succeeds). Today isolation is Unix permissions on the DB only; any agent can write as any other agent.

- [ ] Is that acceptable for the shared workspace, or do we want per-agent signing (secrets in each agent's home, chmod 600 per skogfences)?
- [ ] If signing: does the CLI need a patch/upstream PR to sign when a secret exists, and inbox to --verify?
- [ ] Alternative: enforce sender == $USER in a wrapper launcher.

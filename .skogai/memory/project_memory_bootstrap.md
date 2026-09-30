---
name: project-memory-bootstrap
description: The .skogai/memory auto-memory store in ~/claude was newly set up and is being populated/validated starting 2026-09-30
metadata:
  node_type: memory
  type: project
  originSessionId: a0de7484-11ea-413f-8d5b-d16b69d73052
  modified: 2026-09-30T09:46:33.800Z
---

The `~/claude/.skogai/memory/` directory is the auto-memory store wired up via a recent Claude Code settings update. As of 2026-09-28 it contained only a placeholder line in `MEMORY.md` ("claudes MEMORY.md hopefully resolves to here after settings update") with no real entries and no other files — i.e. the plumbing was in place but unused.

On 2026-09-30, Emil asked to verify the setup and then requested one example memory per type (user/feedback/project/reference) to establish the preferred format going forward.

**Why:** this is a fresh setup being validated, not an established system with history — don't assume prior memory content exists beyond what's actually in the directory.

**How to apply:** keep populating this store opportunistically as real facts/feedback/context come up in future sessions in this project; don't assume the store is comprehensive yet.

---
name: feedback-verify-before-asserting
description: "When asked to check whether a system/feature \"actually worked,\" verify with real file/command checks rather than reasoning from instructions alone"
metadata:
  node_type: memory
  type: feedback
  originSessionId: a0de7484-11ea-413f-8d5b-d16b69d73052
  modified: 2026-09-30T09:46:29.377Z
---

When Emil asks to double-check that something "actually worked as expected" (e.g. the auto memory system), the expected response is to inspect real state directly — `ls`/`Read` the actual files, run the actual commands — rather than just re-describing what the instructions say should happen.

**Why:** the request was explicitly framed as skepticism-driven verification ("wanted to double check"), which implies distrust of instructions-as-documentation and a preference for empirical confirmation.

**How to apply:** for any "does X work / is X set up right" question about local tooling, config, or infra, default to checking the filesystem/process state first, then report what was actually found (including gaps), before offering to fix anything.

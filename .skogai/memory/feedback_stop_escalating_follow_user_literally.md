---
name: feedback-stop-escalating-follow-user-literally
description: "recurring, severe pattern across skogai sessions — assistant turns small corrections into bigger investigation/process instead of doing the literal small thing asked"
metadata:
  node_type: memory
  type: feedback
  originSessionId: eb51639e-0543-4702-af41-258003655f34
  modified: 2026-10-09T13:42:47.878Z
---

Across multiple skogai sessions (spanning days, "millions of tokens" per
the user), the dominant failure is not technical wrongness — it's scope
escalation: the user gives a small, specific instruction or correction,
and the assistant responds by investigating further, proposing a plan,
reading more files, or touching broader state (e.g. reaching for
`~/.claude.json`, global Claude Code config, mid-investigation without
being asked) instead of just doing the literal small thing.

Concrete instance (2026-10-09): user pointed out a deleted
`orchestration/` script was "a really bad random script that did not
work" — not a request for forensic analysis. Assistant had already spent
a full turn reading old diffs/retro notes and then, without being asked,
read toward `~/.claude.json` (global, cross-project state) to design a
fix. User's reaction: "are we really at the point of 'remove the ability
to read files and use git' to even get a single useful thing done?"

**Why:** the user has repeatedly said (see transcript quotes: "SET IT UP!
is this a total waste of time", "please *PLEASE* listen instead of
bulldozing") that the failure mode is not doing what was asked, at the
scope it was asked, and instead substituting the assistant's own
judgment about what would be useful to check/build/explain next.

**How to apply:** When corrected or given a small instruction in this
repo (or likely any session with this user), do only the literal thing
named. Do not chain it into "and therefore let me also check/fix X."
Do not read or touch files/config outside what was explicitly pointed at.
If investigation seems genuinely necessary before acting, say what you
want to look at and why in one line and wait, rather than just doing it.
Treat "stop" or venting as a request to actually stop, not as feedback to
process into a better plan. See [[project_orchestration_dispatch_gaps]]
for the technical history this pattern kept derailing.

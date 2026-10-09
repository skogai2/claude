---
name: project-orchestration-dispatch-gaps
description: "known gaps in the herdr-based work-order dispatch pipeline (skogai/orchestration), found during the first real dispatch batch"
metadata:
  node_type: memory
  type: project
  originSessionId: 9c05e471-0027-4455-b89c-ecb53ae0de47
  modified: 2026-10-08T19:16:03.935Z
---

First real test of `orchestration/dispatch.sh` (skogai repo, 2026-10-07/08):
7 work orders, one repo each, task "add a SKOGAI.md". All 7 ran and opened
PRs; 4 merged. Full writeup: `orchestration/RETRO-first-dispatch.md` in the
skogai repo.

Gaps found, Emil is speccing solutions for these (as of 2026-10-08):

1. `dispatch.sh` almost always hits Claude Code's first-run folder-trust
   dialog on a brand-new worktree path and exits 1 before sending the
   order — needs manual `herdr agent send-keys`/`read`/`get` to clear.
   Likely fix: pre-seed `hasTrustDialogAccepted: true` for the new
   worktree path in `~/.claude.json`'s `projects` map (keyed by absolute
   path) right after `herdr worktree create`, before `herdr agent start`.
   Not yet implemented.
2. Other startup dialogs (e.g. "new MCP server found") can block a worker
   the same way — a fix needs to handle "blocked on some startup dialog,"
   not just the trust one specifically.
3. No push notification when a worker finishes — `herdr notification` is
   a one-way desktop toast, not a subscribable event. Current workaround:
   orchestrator blocks on `herdr agent wait <name>` per worker in one
   turn. Doesn't survive across sessions/turns or scale past "stay and
   watch."
4. `repo:` in an order isn't guaranteed to be an independent git checkout.
   `projects/skogai-routing` has no `.git` of its own (plain files in the
   `skogai` monorepo) — dispatching against it would have branched the
   whole orchestrator repo. No automated check for this exists yet.
5. Order `status:` frontmatter is reconciled by hand, after the fact
   (`running`→recorded only on a clean dispatch; `pr-open`→`done` only
   when someone notices the PR merged and edits the file). Not
   automatically trustworthy as a record of truth yet.
6. Order content is ~90% copy-paste boilerplate across similar orders —
   a generator script would help once more batches like this happen.

**Why this matters:** Emil's stated goal is "not only should you be able
to create workorders but also follow them up all the way via automation"
— i.e. the gap between creating an order and knowing (without asking)
that it's done and merged should close. [[project_agent_homes_architecture]]
has related skogai-wide context.

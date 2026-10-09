---
name: project-okf-adoption-proposal
description: skogai repo now has a real OKF v0.2 knowledge bundle at .skogai/knowledge, replacing the old draft proposal
metadata:
  node_type: memory
  type: project
  originSessionId: a5d5c95b-cd66-42ef-b016-eb88803188ee
  modified: 2026-10-09T10:22:31.575Z
---

Settled and acted on: skogai now has a real Open Knowledge Format (OKF)
v0.2 bundle at `.skogai/knowledge` in the `skogai` repo (committed
2026-10-09, commit `089ab05`), built with `openknowledge scaffold` /
`openknowledge setup complete`. Rules enabled: `project`, `writing`,
`decisions`, `agents`, `changelog`. Connected read-write under registry
key `skogai`. A project-scoped Claude skill
(`.claude/skills/openknowledge/SKILL.md`) and knowledge-gap observation
(`.claude/settings.json` Stop hook) are active.

**Why:** The earlier draft proposal (`.skogai/proposals/proposal-okf-adoption.md`)
and the hand-rolled `.skogai/knowledge/DECISIONS.md` +
`.skogai/proposals/types-and-decisions.md` were an unfinished attempt to
reinvent decision-file conventions (frontmatter fields, numbering, index
vs. hand-maintained list) that the OKF spec already defines. Emil chose a
clean start: delete those drafts rather than migrate them, scaffold a
real bundle, and record the switch itself as the bundle's first decision
(`.skogai/knowledge/decisions/0001-adopt-okf.md`).

**How to apply:** Don't reference the old proposal/decisions file paths —
they're gone. Future decisions in this repo go in
`.skogai/knowledge/decisions/` as OKF concept files (`type: Decision`).
Use `openknowledge search .skogai/knowledge "<query>"` to query it, and
`openknowledge validate --spec 0.2 .skogai/knowledge` after edits. See
[[feedback_skogai_write_and_commit_immediately]] for the write/commit
convention this followed.

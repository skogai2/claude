---
name: feedback-skogai-write-and-commit-immediately
description: "in skogai repos, write decisions/changes to disk immediately and keep everyday work at least staged, usually committed"
metadata:
  node_type: memory
  type: feedback
  originSessionId: a5d5c95b-cd66-42ef-b016-eb88803188ee
  modified: 2026-10-09T05:25:05.386Z
---

In any skogai repo (this one, and others under the [[user_skogai_system]]
umbrella), don't hold decisions or edits in a scratch list / in-context
summary waiting for a batch write. Write them to disk as soon as they're
agreed, even if small or not yet numbered/finalized.

Everyday changes in skogai repos should be at least `git add`-staged, and
normally committed, rather than left dangling uncommitted across a
session or between sessions.

**Why:** Emil's rule, stated 2026-10-09 during a rapid-fire decisions
session: "all changes should be made as soon as possible to disk" and
"everything skogai is made to have changes be at least staged but
committed in everyday situations." Matches [[feedback_no_external_source_of_truth]]
— uncommitted/unwritten state is exactly the kind of informal
source-of-truth-drift that causes problems here.

**How to apply:** When Emil states a decision (even an informal
one-liner), write it to the appropriate file under `.skogai/knowledge/`
right away — use an unnumbered "proposal" file if the decision itself
isn't settled yet (see [[project_okf_adoption_proposal]]) — then stage
and commit it, rather than waiting to batch multiple decisions into one
commit. Still ask before committing if the change is risky or the user
seems to be mid-thought rather than stating a settled rule.

---
state: backlog
created: 2026-09-30T13:32:48.502206+00:00
priority: medium
task_type: action
assigned_to: bob
tags: ["git", "worktree", "submodules"]
---

# Init submodules on worktree creation

Fresh git worktrees don't check out submodules, so `gptme-contrib/` is empty.
The pre-commit hook `check-names` runs `gptme-contrib/scripts/precommit/check-names.sh`
and fails with "No such file or directory" until the submodule is initialised.
Hit on 2026-09-30 when committing from a worktree; fixed manually with
`git submodule update --init gptme-contrib`.

Make worktree creation initialise submodules automatically, so commits work
from the first moment in a new worktree.

## Options to consider

- A `post-checkout` hook that runs `git submodule update --init` when a new
  worktree is created (note `core.hooksPath` is global here, see
  `decide-on-global-core-hookspath-scope`).
- A Claude Code `WorktreeCreate`/session-start hook in `.claude/`.
- Set `submodule.recurse` / use `git worktree add` wrappers (`gptodo worktree`)
  that init submodules.

## Done when

- [ ] Creating a new worktree leaves `gptme-contrib/` populated
- [ ] A commit from a fresh worktree passes pre-commit without manual steps

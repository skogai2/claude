---
state: backlog
created: 2026-09-30T13:14:38.329834+00:00
priority: high
task_type: action
assigned_to: bob
tags: ["git", "decision"]
---

# Decide on global core.hooksPath scope

core.hooksPath is currently set globally (not repo-local) to
~/claude/dotfiles/.config/git/hooks, via dotfiles/install.sh having
been run once already. This affects every git repo on the machine,
including ~/dot, which is otherwise off-limits to this project.

The identity guard in that hook was patched (dotfiles/.config/git/allowed-identities.conf,
IDENTITY_ALLOWLIST=("emil@skogsund.se")) so commits work again, but
the underlying question is still open: keep core.hooksPath global
(accepting ~/claude's dotfiles as the machine-wide git hook source),
or revert to repo-local hooks only?

See .skogai/memory/project_global_git_hooks_landmine.md for full detail.

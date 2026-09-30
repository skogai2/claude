---
name: project-global-git-hooks-landmine
description: "core.hooksPath is set GLOBALLY (all repos, not just ~/claude) to ~/claude/dotfiles/.config/git/hooks; its identity guard was patched but the global scope itself is still an open question"
metadata:
  node_type: memory
  type: project
  modified: 2026-09-30T13:09:55.207Z
  originSessionId: e4c3ca13-101f-4d92-9eb5-0a81ab535fc7
---

On 2026-09-30, during the [[project_agent_homes_architecture]] template adoption, a `git commit` in `~/claude` started failing with `ABORT: git user.email 'emil@skogsund.se' is NOT an allowed identity`. Root cause, discovered mid-session:

1. Someone (not this session — found already done) ran `~/claude/dotfiles/install.sh`, which:
   - symlinked `~/.config/git/hooks` → `~/claude/dotfiles/.config/git/hooks`
   - ran `git config --global core.hooksPath ~/.config/git/hooks`
2. Because `core.hooksPath` is a **global** git setting, that one `pre-commit` script now runs before every commit in **every** repo on this machine — including `~/dot`, which is otherwise off-limits to this project.
3. That `pre-commit` script (copied in wholesale from `claude-minimal`, itself copied from the upstream `gptme-agent-template`) hardcodes an identity allowlist for the template's original author — `bob@superuserlabs.org` / `timetobuildbob@gmail.com` — and rejects any other `git config user.email`.
4. Fixed via the hook's own documented override point (not by editing the shared hook script): created `~/claude/dotfiles/.config/git/allowed-identities.conf` with `IDENTITY_ALLOWLIST=("emil@skogsund.se")`. The hook does `source "$HOOK_DIR/../allowed-identities.conf" 2>/dev/null || true` before checking, so this file is picked up automatically.

**Still true right now**: `core.hooksPath` is global and points at `~/claude`'s dotfiles. This was flagged to Emil (2026-09-30) and left unresolved — he hasn't said whether to revert it (repo-local hooks only) or keep it (accepting `~/claude`'s dotfiles as the machine-wide git hook source, including for `~/dot`).

**Why this matters for future sessions:**
- A commit failing with an unfamiliar identity/branch/mass-deletion guard message, **in any repo on this machine**, may be this hook, not something specific to that repo.
- `ALLOW_GIT_IDENTITY=1 git commit ...` bypasses the identity check for one commit if needed.
- Don't "fix" a future identity-guard failure by loosening `dotfiles/.config/git/hooks/pre-commit` itself — that file is meant to stay close to the shared upstream version; add/edit `allowed-identities.conf` instead.
- Don't unilaterally revert `core.hooksPath` to fix this either — check with Emil first, since it's a global change this session didn't originate and other work may now assume it's active.

**How to apply:** if a git operation anywhere on this machine throws an unexpected hook error, check `git config --global core.hooksPath` and `~/claude/dotfiles/.config/git/hooks/pre-commit` before assuming it's repo-specific. See [[project_agent_homes_architecture]].

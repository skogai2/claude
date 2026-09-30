---
name: project-agent-homes-architecture
description: "skogai2 org hosts separate per-agent home-folder repos; ~/claude is Claude Code's own home, now built as a full gptme-agent-template instance (not the lighter agent-workspace-plugin)"
metadata:
  node_type: memory
  type: project
  modified: 2026-09-30T12:34:11.246Z
  originSessionId: e4c3ca13-101f-4d92-9eb5-0a81ab535fc7
---

Emil's "skogfences" project (see the manifesto in `.skogai/messages/skogix.md`) gives each AI agent runtime its own real home directory instead of a sandbox. Each home is a separate git repo pushed to the `github.com/skogai2` org (a distinct org from Emil's own `Skogix` GitHub account):

- `~/dot` -> `skogai2/dot` — a **gptme** agent's home, scaffolded from the full [gptme/gptme-agent-template](https://github.com/gptme/gptme-agent-template): Thompson-sampling/BM25 lesson matching, `gptme-sessions` tracking, a `gptme-contrib` git submodule, `gptodo` CLI, `uv`/`mypy`/`pre-commit`, systemd/launchd autonomous runners. **Off-limits** — Emil was explicit (2026-09-30) that `dot` is not to be touched from here.
- `~/claude` -> `skogai2/claude` — **this** repo, Claude Code's own home. This is the one being actively built/changed in this project.
- `~/skogai` and `~/.config/skogai` — the human-facing router/config layer described in [[reference_skogai_config_routes]], separate from either agent home.

Reference clones of related gptme tooling live under `~/.local/src/` (not part of any agent home): `gptme` itself, `gptme-agent-template`, `gptme-contrib`, and three Claude-Code-specific packages — `gptme-cc-plugin` (skills that delegate work TO the gptme CLI), `gptme-skills-cc` (general-purpose skill pack: code-review, persistent-learning, progressive-disclosure, git-workflow), and `agent-workspace-plugin` (a lightweight Claude Code plugin reimplementing gptme-agent-template's tasks/journal/lessons/knowledge/people pattern with zero Python-tooling dependencies).

On 2026-09-30 the approach went through several iterations in one session:

1. First seeded with `agent-workspace-plugin`'s lightweight structure (project-local skills/commands/hooks, zero Python tooling) — later removed ("remove handmade version").
2. Switched to installing `agent-workspace-plugin` as a real marketplace plugin — ended up disabled and effectively abandoned.
3. Added `gptme/gptme-contrib` as a git submodule at `gptme-contrib/` (real dependency, kept).
4. Emil separately ran a fresh `gptme-agent-template` init at `~/claude-minimal` (full vanilla template, agent name pre-filled "claude", identity docs still placeholders) and asked for a comparison against the plugin approach.
5. Decision: **replace `~/claude` wholesale** with the `claude-minimal` template rather than keep the lighter scaffold. All 53 tracked files from `claude-minimal` were copied in (commit `cc79c2f`), superseding the plugin-based approach entirely.

**Current state of `~/claude`**: a full `gptme-agent-template` instance —
- Identity docs: `ABOUT.md`, `SOUL.md`, `ARCHITECTURE.md`, `TOOLS.md`, `WORKFLOW.md`, `AGENTS.md`, `TASKS.md`, `README.md` (still template placeholders, not yet written for a real persona — `tasks/initial-agent-setup.md` is the onboarding task for that).
- `gptme.toml` — config; `[lessons] dirs` currently includes both this repo's own `lessons/`/`skills/` *and* the bulk `gptme-contrib/lessons`/`gptme-contrib/skills` directories.
- `.claude/hooks/match-lessons.py` + `post-session.py` — the real mechanism (ported from `~/dot`, not reinvented): `match-lessons.py` fires on `UserPromptSubmit` and `PreToolUse` (matcher `Read|Bash|Grep|WebFetch|WebSearch`) and auto-injects keyword-matched lessons as context; `post-session.py` auto-logs on `Stop`. **Verified working live** in this session — but because `[lessons] dirs` includes the full `gptme-contrib` corpus, it fires on nearly every Read/Bash call and often injects loosely-relevant upstream skills (e.g. a Home Assistant skill triggered by an unrelated `ls`). Worth narrowing `[lessons] dirs` to just this repo's own `lessons/`/`skills/` if the noise becomes annoying — not yet done, left as Emil's call.
- Full pre-commit/Python toolchain (`ruff`, `mypy`, `shellcheck`, `prek`) plus `gptme-contrib`'s own validators (root-structure allowlist, task frontmatter, markdown links, agent-name collision). All hooks verified green as of `cc79c2f` — fixed a stale `shellcheck source=` path, added `types-PyYAML`, and dropped two dangling `knowledge/portable-agent-apps.md` links the vanilla template shipped with.
- `.github/root-structure-allowlist.yaml` explicitly allowlists `.skogai`, `CLAUDE.md`, and `tmp` (gitignored scratch space) alongside the template's own entries, so the root-structure validator doesn't reject skogai-specific files.
- `scripts/runs/autonomous/autonomous-run-cc.sh` — runs Claude Code (`claude -p --dangerously-skip-permissions`) autonomously with a system prompt built from the identity files, gated by `gptme-contrib`'s quota-gate/session-gate scripts. Not yet exercised.
- `gptodo` (installed via `uv tool`, on PATH) works against `tasks/` with zero extra config — full CRUD/readiness/dependency workflow (`add`/`list`/`show`/`next`/`explain`/`lint`/`check`/`edit`/`claim`/`status`/`ready`/`generate-queue`) confirmed working out of the box. `spawn`/`run` (sub-agent orchestration, supports `--backend claude`) and `import`/`fetch`/`sync` (GitHub/Linear) exist but are untested.

This `lessons/` dir is a **separate** keyword-matched system from `.skogai/memory/` (Claude Code's native auto-memory used by this session type). They intentionally coexist: `.skogai/memory/` for facts/feedback/user/project/reference context loaded by relevance; `lessons/` (plus the hook) for automatic keyword-triggered context injection.

**Why:** the earlier "light, no Python toolchain" goal was superseded by Emil's explicit choice, after seeing both side by side, to adopt the real template wholesale rather than a hand-rolled subset — full gptme-workspace parity mattered more than avoiding the toolchain.

**How to apply:** any future work on "the home folder setup" defaults to `~/claude` unless Emil says otherwise. Never extend this to modify `~/dot` without being asked again. `~/claude-minimal` was the source of this merge and can be treated as consumed/reference-only unless Emil says it's still an active separate workspace. Follow the real template's own conventions (`AGENTS.md`, `gptme.toml`, `gptodo` task schema) rather than the old plugin's. See [[user_skogai_system]] and [[reference_skogai_config_routes]].

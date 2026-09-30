---
name: project-agent-homes-architecture
description: "skogai2 org hosts separate per-agent home-folder repos; ~/claude is Claude Code's own home and is being built as a light gptme-workspace clone"
metadata:
  node_type: memory
  type: project
  modified: 2026-09-30T11:23:03.234Z
  originSessionId: cfc4757a-d7fd-4615-bbe3-3323ae51d98e
---

Emil's "skogfences" project (see the manifesto in `.skogai/messages/skogix.md`) gives each AI agent runtime its own real home directory instead of a sandbox. Each home is a separate git repo pushed to the `github.com/skogai2` org (a distinct org from Emil's own `Skogix` GitHub account):

- `~/dot` -> `skogai2/dot` — a **gptme** agent's home, scaffolded from the full [gptme/gptme-agent-template](https://github.com/gptme/gptme-agent-template): Thompson-sampling/BM25 lesson matching, `gptme-sessions` tracking, a `gptme-contrib` git submodule, `gptodo` CLI, `uv`/`mypy`/`pre-commit`, systemd/launchd autonomous runners. **Off-limits** — Emil was explicit (2026-09-30) that `dot` is not to be touched from here.
- `~/claude` -> `skogai2/claude` — **this** repo, Claude Code's own home. This is the one being actively built/changed in this project.
- `~/skogai` and `~/.config/skogai` — the human-facing router/config layer described in [[reference_skogai_config_routes]], separate from either agent home.

Reference clones of related gptme tooling live under `~/.local/src/` (not part of any agent home): `gptme` itself, `gptme-agent-template`, `gptme-contrib`, and three Claude-Code-specific packages — `gptme-cc-plugin` (skills that delegate work TO the gptme CLI), `gptme-skills-cc` (general-purpose skill pack: code-review, persistent-learning, progressive-disclosure, git-workflow), and `agent-workspace-plugin` (a lightweight Claude Code plugin reimplementing gptme-agent-template's tasks/journal/lessons/knowledge/people pattern with zero Python-tooling dependencies).

On 2026-09-30, `~/claude` was seeded with `agent-workspace-plugin`'s structure (project-local, not a global plugin install, so it stays portable with the repo): root dirs `tasks/`, `journal/`, `lessons/{patterns,tools,workflow}`, `knowledge/`, `people/`; and `.claude/commands/{workspace-init,workspace-status,journal}.md`, `.claude/skills/{task-management,lessons,autonomous-run}/SKILL.md`, `.claude/hooks/validate_task.py` + `.claude/settings.json` wiring it via `$CLAUDE_PROJECT_DIR` (adapted from the plugin's `${CLAUDE_PLUGIN_ROOT}`, since this isn't installed as an actual plugin). See `.claude/THIRD_PARTY_NOTICES.md` for the MIT attribution.

This new `lessons/` dir is a **separate** keyword-matched system from `.skogai/memory/` (Claude Code's native auto-memory used by this session type). They intentionally coexist: `.skogai/memory/` for facts/feedback/user/project/reference context loaded by relevance; `lessons/` for explicit keyword-triggered behavioral rules, per the plugin's own convention.

**Why:** Emil is building "a claude version, which is a light version of the gptme setup" — i.e. give Claude Code's own home the same persistence benefits (tasks, journal, knowledge, self-improving lessons) as a full gptme agent, without carrying gptme's heavy Python toolchain.

**How to apply:** any future work on "the home folder setup" defaults to `~/claude` unless Emil says otherwise. Never extend this to modify `~/dot` without being asked again. When adding to `~/claude`'s workspace, follow the conventions already copied from `agent-workspace-plugin` (task frontmatter schema, append-only journal, lesson format) rather than reinventing them. See [[user_skogai_system]] and [[reference_skogai_config_routes]].

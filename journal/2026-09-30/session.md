## Session: home-folder-setup

**Date**: 2026-09-30

### Work
- Surveyed the existing skogai infrastructure: `~/skogai`, `~/.config/skogai`, and this repo (`~/claude`), all synced to the `skogai2` GitHub org — a separate identity from Emil's own `Skogix` account.
- Found `~/dot`, a gptme agent's home freshly pushed as `skogai2/dot`, scaffolded from the full `gptme/gptme-agent-template` (Thompson-sampling/BM25 lesson matching, `gptme-sessions`, `gptme-contrib` submodule, `gptodo`, `uv`/`mypy`/`pre-commit`, systemd/launchd autonomous runners).
- Identified `~/.local/src/agent-workspace-plugin` as the lightweight Claude Code equivalent: same tasks/journal/lessons/knowledge/people pattern, zero Python-tooling dependencies, just plugin commands/skills/one hook.
- Confirmed with Emil that `~/dot` is off-limits — the "light Claude version" work targets `~/claude` (this repo) instead.
- Seeded `~/claude` with the `agent-workspace-plugin` structure: root dirs `tasks/`, `journal/`, `lessons/{patterns,tools,workflow}`, `knowledge/`, `people/` (with starter READMEs), plus project-local `.claude/commands/{workspace-init,workspace-status,journal}.md`, `.claude/skills/{task-management,lessons,autonomous-run}/SKILL.md`, and `.claude/hooks/validate_task.py` wired via `.claude/settings.json` (`$CLAUDE_PROJECT_DIR`, adapted from the plugin's `${CLAUDE_PLUGIN_ROOT}` since this is a project-local copy, not a global plugin install).
- Added `.claude/THIRD_PARTY_NOTICES.md` (MIT attribution to gptme/agent-workspace-plugin, Superuser Labs).
- Tested `validate_task.py` manually against a bad task frontmatter — correctly flagged the invalid state.
- Committed the above as `32bc2f3` (not yet pushed — pending Emil's go-ahead).
- Recorded the architecture in `.skogai/memory/project_agent_homes_architecture.md` so future sessions don't have to re-derive `~/dot` vs `~/claude`, or why `lessons/` coexists with `.skogai/memory/`.

### Decisions
- Copied the plugin's files project-locally into `.claude/` rather than installing it globally via `claude plugin install` — keeps the home folder portable with the repo, matching the "context travels with its home directory" principle from the skogfences manifesto (`.skogai/messages/skogix.md`), and matches the pattern `~/dot` already uses for its own `.claude/`.
- Kept `lessons/` (keyword-triggered behavioral rules) as a distinct system from `.skogai/memory/` (Claude Code's native, relevance-loaded auto-memory) rather than merging them or dropping one — documented the split in `lessons/README.md`.
- Left `~/dot` completely untouched per Emil's explicit correction.

### Next Steps
- Awaiting Emil's decision on whether to push `32bc2f3` to `skogai2/claude`.
- Consider whether the four still-TODO routes in `~/skogai/SKOGAI.md` (`dot-skogai`, `dash-skogai`, `skogix`, `claude`) should now point at this workspace structure, or stay separate — not yet resolved.
- No tasks have been created yet in `tasks/` — first real use of the task-management skill is still pending.

# Lessons

Behavioral lessons that prevent known failure modes.

Each lesson has YAML frontmatter with `match.keywords` for automatic activation, plus Rule, Context, Pattern, and Outcome sections. Keep under 50 lines.

Categories:
- `patterns/` - Cross-cutting behavioral patterns
- `tools/` - Tool-specific lessons
- `workflow/` - Process and workflow lessons

Note: this is a separate, keyword-matched system from `.skogai/memory/`
(Claude Code's native auto-memory, loaded by relevance every session). Use
`.skogai/memory/` for facts about the user/project/feedback; use `lessons/`
for concrete behavioral rules worth encoding as an explicit trigger.

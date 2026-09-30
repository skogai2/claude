---
name: lessons
description: Create behavioral lessons that capture patterns, prevent failure modes, and build compound knowledge. Use when you discover a reusable insight, fix a recurring mistake, or want to persist a behavioral pattern.
---

# Behavioral Lessons

Lessons are concise rules that prevent known failure modes and encode successful patterns. They live in `lessons/` and are organized by category.

## When to Create a Lesson

- You discovered a pattern that would prevent a past mistake
- A fix or workaround should be remembered across sessions
- A tool has non-obvious behavior worth documenting
- A workflow decision should be consistently applied

## Lesson Format

```markdown
---
match:
  keywords:
    - "specific trigger phrase"
    - "another trigger condition"
status: active
---

# Lesson Title

## Rule
One-sentence imperative: what to do or avoid.

## Context
When this applies (trigger condition).

## Pattern
Minimal correct example (2-10 lines of code or steps).

## Outcome
What happens when you follow this:
- Benefit 1
- Benefit 2
```

## Creating a Lesson

1. Choose a category: `patterns/`, `tools/`, or `workflow/`
2. Use a descriptive kebab-case filename: `lessons/tools/always-quote-paths.md`
3. Write 3-7 keyword phrases that describe when this lesson should activate
4. Keep under 50 lines — concise rules, not documentation
5. Commit with message: `lesson: <description>`

## Keywords

Keywords should be **multi-word phrases** that match real situations:
- "file path with spaces" (specific trigger)
- "command not found after install" (problem indicator)
- "test failing intermittently" (behavioral signal)

Avoid single-word keywords like "git" or "test" — too broad.

## Categories

- **patterns/**: Cross-cutting behavioral patterns (e.g., "always persist before applying")
- **tools/**: Tool-specific lessons (e.g., "quote paths in shell commands")
- **workflow/**: Process lessons (e.g., "commit early, commit often")

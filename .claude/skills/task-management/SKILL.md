---
name: task-management
description: Create, update, and query structured task files with YAML frontmatter. Use when working with tasks, updating task state, managing priorities, or tracking work items.
---

# Task Management

Manage tasks as Markdown files with YAML frontmatter in the `tasks/` directory.

## Task File Format

```yaml
---
state: active           # Required: backlog, todo, active, waiting, done, cancelled
created: 2026-01-01T00:00:00Z  # Required: ISO 8601
priority: medium        # Optional: low, medium, high
tags: [feature, ai]     # Optional: categorization
depends: [other-task]   # Optional: dependencies (task file basenames)
next_action: "..."      # Optional: immediate concrete action
waiting_for: "..."      # Optional: what/who is blocking
---
# Task Title

Description of what needs to be done.

## Subtasks
- [ ] First step
- [x] Completed step
```

## State Transitions

```txt
backlog -> todo -> active -> done
                      |
                   waiting -> active
                      |
                  cancelled
```

## Operations

### Create a Task

Write a new file to `tasks/` with the frontmatter format above. Use `date -Iseconds` for the `created` timestamp. Choose a kebab-case filename that describes the task.

### Update Task State

Edit the YAML frontmatter `state` field. When moving to `waiting`, also set `waiting_for`. When moving to `active`, set `next_action` to clarify the immediate step.

### Query Tasks

```bash
# List active tasks
grep -l "^state: active" tasks/*.md 2>/dev/null

# List by priority
grep -l "^priority: high" tasks/*.md 2>/dev/null

# Count by state
for s in active todo backlog waiting done; do
  c=$(grep -rl "^state: $s" tasks/*.md 2>/dev/null | wc -l)
  [ "$c" -gt 0 ] && echo "$s: $c"
done
```

## Best Practices

1. **Scope over time**: Assess complexity by components/impact, not time estimates
2. **Complete at MVP**: Mark done when core works; create follow-ups for enhancements
3. **Use next_action**: "What do I do right now?" — specific and actionable
4. **No dynamic info**: Don't embed progress counters in files; query live instead

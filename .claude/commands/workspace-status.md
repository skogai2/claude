---
description: Show agent workspace status — tasks, recent journal entries, lessons, and git state
allowed-tools: [Bash, Read, Glob, Grep]
---

# Workspace Status

Show a comprehensive overview of the agent workspace state.

## Instructions

Gather and display workspace status across these dimensions:

### 1. Tasks

```bash
for state in active todo backlog waiting done cancelled; do
  count=$(grep -rl "^state: $state" tasks/*.md 2>/dev/null | wc -l)
  [ "$count" -gt 0 ] && echo "$state: $count"
done
```

Show active task titles:
```bash
grep -l "^state: active" tasks/*.md 2>/dev/null | while read f; do
  title=$(grep "^# " "$f" | head -1 | sed 's/^# //')
  echo "  - $title ($(basename "$f" .md))"
done
```

### 2. Recent Journal

Show the 3 most recent journal entries:
```bash
find journal/ -name "*.md" -not -name "README.md" -type f 2>/dev/null | sort -r | head -3
```

### 3. Lessons

Count total lessons:
```bash
find lessons/ -name "*.md" -not -name "README.md" -type f 2>/dev/null | wc -l
```

### 4. Git State

Show uncommitted changes and recent commits:
```bash
git status --short
git log --oneline -5
```

Present results in a clean, concise format. Highlight items needing attention (uncommitted changes, tasks waiting too long, active tasks without next_action).

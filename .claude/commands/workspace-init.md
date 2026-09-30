---
description: Initialize a persistent agent workspace with task management, journal, lessons, and knowledge base
allowed-tools: [Bash, Write, Read, Glob]
---

# Initialize Agent Workspace

Set up a persistent workspace structure for autonomous AI agent operation. This creates a git-tracked "brain" with structured directories for tasks, journal entries, lessons learned, and a knowledge base.

## Instructions

1. Check if a workspace already exists by looking for `tasks/`, `journal/`, `lessons/`, and `knowledge/` directories. If they exist, report the current state instead of recreating.

2. If no workspace exists, create the following structure:

```bash
mkdir -p tasks journal lessons/{patterns,tools,workflow} knowledge people
```

3. Create starter README files for each directory:

**tasks/README.md**:
```markdown
# Tasks

Task files use YAML frontmatter for metadata. See the `task-management` skill for the full format.

States: backlog -> todo -> active -> waiting -> done/cancelled
```

**journal/README.md**:
```markdown
# Journal

Daily append-only logs organized by date.

Structure: `journal/YYYY-MM-DD/session-name.md`

Rules:
- Never modify historical entries
- One subdirectory per day
- Each session gets its own file
```

**lessons/README.md**:
```markdown
# Lessons

Behavioral lessons that prevent known failure modes.

Each lesson has YAML frontmatter with `match.keywords` for automatic activation, plus Rule, Context, Pattern, and Outcome sections. Keep under 50 lines.

Categories:
- `patterns/` - Cross-cutting behavioral patterns
- `tools/` - Tool-specific lessons
- `workflow/` - Process and workflow lessons
```

**knowledge/README.md**:
```markdown
# Knowledge Base

Long-term documentation, design docs, and reference materials.
Organized by topic. Updated as understanding deepens.
```

4. Initialize git if not already a git repository:
```bash
git init
git add -A
git commit -m "feat: initialize agent workspace"
```

5. Report what was created and suggest next steps:
   - Create a first task: `/agent-workspace:task-management`
   - Start a journal entry: `/agent-workspace:journal`
   - Write a lesson from experience: check the `lessons` skill

---
description: Create or append to today's journal entry
argument-hint: [session-name]
allowed-tools: [Bash, Write, Read]
---

# Journal Entry

Create or append to a journal entry for today. Journal entries are append-only daily logs that capture work, decisions, and progress.

## Arguments

The user invoked this command with: $ARGUMENTS

If a session name is provided, use it. Otherwise, generate a descriptive name based on the current work.

## Instructions

1. Determine today's date and create the journal directory:

```bash
today=$(date +%Y-%m-%d)
mkdir -p "journal/$today"
```

2. Determine the session file name:
   - If `$ARGUMENTS` is provided, use it: `journal/$today/$ARGUMENTS.md`
   - Otherwise, use `session.md`

3. Create or append the journal entry with this structure:

```markdown
## Session: [session-name]

**Date**: [today's date]

### Work
- [What was accomplished]

### Decisions
- [Key decisions made and rationale]

### Next Steps
- [What should happen next]
```

4. If the file already exists, **append** to it (never overwrite journal entries).

5. Confirm the entry was created and show its path.

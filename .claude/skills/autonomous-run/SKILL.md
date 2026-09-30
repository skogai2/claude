---
name: autonomous-run
description: Execute an autonomous work session — assess loose ends, select work via cascade, execute, and journal. Use when running the agent without human direction or when asked to "work autonomously" or "pick your own work".
---

# Autonomous Run

Execute a structured autonomous work session. This skill turns Claude Code into a persistent agent that maintains state across sessions, selects its own work, and journals progress.

## When to Use

- Running without specific human direction
- Asked to "pick your own work" or "work autonomously"
- Scheduled/cron-triggered sessions
- Continuing interrupted work

## Workflow (4 Phases)

### Phase 1: Assess Loose Ends (~10% of session)

Check for unfinished work from recent sessions:

```bash
# Check git state
git status --short

# Find recent journal entries
today=$(date +%Y-%m-%d)
yesterday=$(date -d yesterday +%Y-%m-%d 2>/dev/null || date -v-1d +%Y-%m-%d)
ls journal/$today/ journal/$yesterday/ 2>/dev/null
```

- If there are uncommitted changes, commit or resolve them
- If recent journal entries mention unfinished work, consider continuing it
- Keep this phase under 5 minutes

### Phase 2: Select Work (CASCADE, ~15% of session)

Try these tiers in order until you find actionable work:

**Tier 1 — Active tasks**: Look for tasks in `active` state:
```bash
grep -rl "^state: active" tasks/*.md 2>/dev/null
```
Read the file, check `waiting_for` — skip if blocked. Prefer a task already in progress.

**Tier 2 — Ready tasks**: If no active tasks, find `todo` or `backlog` items:
```bash
grep -rl "^state: todo" tasks/*.md 2>/dev/null
grep -rl "^state: backlog" tasks/*.md 2>/dev/null
```
Pick the highest-priority unblocked task. Prefer small, self-contained work.

**Tier 3 — Self-improvement**: If all tasks are blocked, do productive internal work:
- Fix failing tests or type errors
- Clean up stale tasks (close completed ones, update metadata)
- Add missing tests for existing code
- Document undocumented patterns as lessons
- Review and improve workspace infrastructure

**Finding work at ANY tier mandates Phase 3 execution.**

### Phase 3: Execute (~70% of session)

Work on the selected task:
- Update task state to `active` if not already
- Set `next_action` in the task frontmatter
- Make real progress: write code, fix bugs, create PRs
- Commit early and often with conventional commit messages
- Run tests before committing

```bash
# Update task state
# Edit tasks/my-task.md frontmatter: state: active

# Commit progress
git add <specific-files>
git commit -m "feat(scope): description of change"
```

### Phase 4: Complete (~5% of session)

1. **Commit all work** — don't leave uncommitted changes
2. **Update task state** — mark done if complete, update `next_action` if not
3. **Journal entry** — record what happened:

```bash
today=$(date +%Y-%m-%d)
session_id=$(date +%H%M)
mkdir -p "journal/$today"
```

Write `journal/$today/autonomous-session-$session_id.md`:

```markdown
# Autonomous Session

**Date**: [today]
**Category**: [what type of work: feature, bugfix, maintenance, etc.]

## Work Done
- [What was accomplished with specific deliverables]

## Decisions
- [Key choices made and why]

## Next Steps
- [What should happen in the next session]

**Complete**: [Yes/No]
```

4. **Push** — if working with a remote:
```bash
git push origin $(git branch --show-current)
```

## Rules

- **No NOOPs**: Every session must produce at least one tangible artifact (commit, task update, journal entry)
- **Scope discipline**: Complete the selected task before pursuing tangential improvements. Note side-discoveries as new tasks instead.
- **Time management**: If stuck for more than 10 minutes, move to the next task
- **Absolute paths**: Use absolute paths for all file operations to prevent misplaced files
- **Append-only journal**: Never modify historical journal entries

## Anti-Patterns

- Spending the entire session on Phase 2 (selection) without executing
- Declaring "everything is blocked" without checking all 3 tiers
- Making changes without committing them
- Ending without a journal entry

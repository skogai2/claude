# Tasks

This document describes and provides instructions for the task management system used in the workspace.

The system provides:

- Structured task tracking with YAML frontmatter metadata
- CLI tools for task management and status tracking
- Pre-commit validation hooks for data integrity
- Integration with journal entries for progress tracking
- Best practices for task creation and management

All task details are maintained as individual Markdown files under `./tasks/`.

## Task CLI Usage

The task system provides a CLI for managing tasks via `gptodo`.

**Installation** (if not already installed):
```sh
uv tool install git+https://github.com/gptme/gptme-contrib#subdirectory=packages/gptodo
```

**Commands**:

```sh
# View task status (overview — includes blocked/waiting tasks)
gptodo status              # Show all tasks
gptodo status --compact    # Show only new/active
gptodo status --type tasks # Show specific type

# Select unblocked work (use this instead of scanning `gptodo status`)
gptodo ready                         # Unblocked backlog/todo/active
gptodo ready --state todo --jsonl    # One state, one JSON object per line
gptodo ready --skip-claimed --jsonl  # Concurrent sessions: hide already-claimed tasks

# List tasks
gptodo list               # List all tasks
gptodo list --sort state  # Sort by state
gptodo list --sort date   # Sort by date

# Show task details
gptodo show <task-id>     # Show specific task
```

### Selecting work (`gptodo ready`)

`gptodo status` is an overview of everything, including blocked and waiting tasks. Concurrent sessions that pick from status will converge on the same blocked work.

`gptodo ready` is the selector: it lists tasks that are genuinely unblocked (no unresolved `depends`, no `waiting_for` blocker). `--state backlog|todo|active|ready_for_review` narrows the pool; `--jsonl` is the machine-readable form for autonomous runners.

For concurrent sessions, add `--skip-claimed`. It hides tasks already held by another coordination session (`state/coordination/coord.db`, keys like `cascade:task:<id>`). If that DB is absent — a typical fresh fork — the flag degrades silently and you still get the unblocked set.

`--skip-claimed` shipped in [gptme-contrib#1510](https://github.com/gptme/gptme-contrib/pull/1510) (2026-08-25). Re-install gptodo from gptme-contrib if `gptodo ready --help` does not list the flag.

### Task Metadata Updates

The task system provides a CLI for updating task metadata:

```sh
# Basic usage
gptodo edit <task-id> [--set|--add|--remove <field> <value>]

# Examples
gptodo edit my-task --set state active       # Set task state
gptodo edit my-task --set priority high      # Set priority
gptodo edit my-task --add tag feature        # Add a tag
gptodo edit my-task --add depends other-task # Add dependency

# Multiple changes
gptodo edit my-task \
  --set state active \
  --add tag feature \
  --add depends other-task

# Multiple tasks
gptodo edit task-1 task-2 --set state done
```

Valid fields and values:

- `--set state`: new, active, paused, done, cancelled
- `--set priority`: high, medium, low, none
- `--add/--remove tags`: any string without spaces
- `--add/--remove depends`: any valid task ID

## Sub-Agent Spawning (`gptodo spawn` / `gptodo run`)

`gptodo` can hand a task off to a fresh agent process instead of working it
in the current session.

```sh
# Synchronous: blocks until done, output returned directly
gptodo run <task-id> --backend claude
gptodo run <task-id> --backend gptme

# Background: launches in tmux and returns immediately
gptodo spawn <task-id> --backend claude
gptodo spawn <task-id> --backend gptme
```

Use `run` when you want to wait for the result in the calling session. Use
`spawn` for a long-running or parallel task; monitor and clean it up with:

```sh
gptodo sessions                 # List all sub-agent sessions (status may be
                                 # stale — see note below)
gptodo output <session-id>      # Refresh status + print output (live tmux
                                 # pane output while running, saved output
                                 # once done)
gptodo kill <session-id>        # Terminate a running background session
```

`gptodo sessions` just lists each session's last-known status from disk — it
does not refresh it. `gptodo output <session-id>` does refresh (it calls
`check_session` internally), so if `sessions` shows something as `running`
long after you'd expect it to be done, run `gptodo output` on it before
assuming it's actually stuck.

### How the prompt is built — and the recursion trap

If you don't pass `--prompt`, `gptodo` builds the sub-agent's entire prompt
from the task file verbatim: `"Work on this task:\n\n# <task-id>\n\n<the
whole markdown body>\n\nFocus on making progress on this task..."`. That
includes *every* section of the task body, with no distinction between
"instructions for the spawned agent" and "a checklist for whoever spawned
it."

This matters because tasks commonly carry a "Done when" / acceptance
checklist meant for the **orchestrator** (the session that ran `gptodo
spawn` and should verify the result afterward) — not for the spawned agent
itself. If that checklist mentions `gptodo spawn`/`run`/`output`/`kill`, a
spawned `claude`-backend agent reading the raw task file can misread it as
its own job and call `gptodo spawn` on the same task again — which spawns a
child that makes the identical mistake, and so on. We hit exactly this
(confirmed 2026-10-02): a single `gptodo spawn ... --backend claude` call
cascaded three generations deep before stopping, because the task's "Done
when" section looked, from inside the sub-agent's prompt, like work it was
supposed to do.

Two mitigations, use both:

1. **Name checklist sections unambiguously** in the task body, e.g.
   `## Orchestrator checklist (for whoever ran \`gptodo spawn\` — NOT
   instructions for the spawned agent above)` instead of a bare `## Done
   when`.
2. **Scope the sub-agent with `--system-prompt-file`** (claude backend
   only — it's passed as `--append-system-prompt-file`):

   ```sh
   gptodo spawn <task-id> --backend claude \
     --system-prompt-file tasks/templates/sub-agent-system-prompt.md
   ```

   `tasks/templates/sub-agent-system-prompt.md` is a ready-made prompt that
   tells the sub-agent: do only the one task you were given, treat any
   "Done when"/"orchestrator checklist" section as not yours to act on,
   never call `gptodo spawn`/`run` yourself, and never pick up extra work
   from `gptodo ready`/`next`. It's worth appending on every `claude`-backend
   spawn, not just ones you suspect are risky — the recursion trap above is
   easy to trigger by accident since it comes from the task file's own
   wording, not from anything unusual about the spawn call.

   This also matters because spawned sessions in this repo inherit the same
   `SessionStart` hook (`scripts/context.sh`) an interactive session gets —
   full task list, journal, git status — so a spawned agent can look and
   feel like a general autonomous agent even though it was only meant to do
   one narrow thing. The system prompt keeps it scoped regardless of what
   ambient context leaks in.

## Task Format

### Task Metadata

Tasks are stored as Markdown files with YAML frontmatter for metadata. The schema is:

```yaml
---
# Required fields
state: active # Task state: new, active, paused, done, cancelled
created: 2025-04-13 # Creation date (ISO 8601)

# Optional fields
priority: high # Priority level: low, medium, high
tags: [ai, dev] # List of categorization tags
depends: [other-task] # List of dependent task IDs
---
```

### Task Body

Example task demonstrating best practices:

```markdown
---
state: active
created: 2025-04-13T18:51:53+02:00
priority: high
tags: [infrastructure, ai]
depends: [implement-task-metadata]
---

# Task Title

Task description and details...

## Subtasks

- [ ] First subtask
- [x] Completed subtask
- [ ] Another subtask

## Notes

Additional notes, context, or documentation...

## Related

- Links to related files
- URLs to relevant resources
```

## Task Lifecycle

1. **Creation**

   - Create new task file in `tasks/` with frontmatter

2. **Activation**

   - Update state in frontmatter to 'active'
   - Create journal entry about starting task
   - Monitor progress with gptodo

3. **Progress Tracking**

   - Daily updates in journal entries
   - Update task metadata as needed
   - Track subtask completion
   - View progress with gptodo

4. **Completion/Cancellation**

   - Update state in frontmatter to 'done'/'cancelled'
   - Final journal entry documenting outcomes

5. **Pausing**
   - Update state in frontmatter to 'paused'
   - Document progress in journal
   - Document pause reason in task description

## Task Validation

Tasks are validated using pre-commit hooks that check:

1. Metadata format and values (as specified in task metadata format above)
2. File structure:
   - Valid markdown syntax
   - Valid internal links

## Best Practices

1. **File Management**

   - Always treat `tasks/` as single source of truth
   - Never modify files directly in state directories
   - Update task state by editing frontmatter
   - Pre-commit hooks validate changes

2. **Task Creation**

   - Use clear, specific titles
   - Break down into manageable subtasks
   - Include success criteria
   - Link related resources
   - Follow metadata format specification

3. **Progress Updates**

   - Regular updates in journal entries
   - Document blockers and dependencies
   - Track progress with gptodo
   - Keep metadata current and accurate

4. **Documentation**

   - Cross-reference related tasks using paths relative to repository root
   - Document decisions and rationale
   - Link to relevant documents and resources
   - Update knowledge base as needed

5. **Linking**
   - Always link to referenced resources (tasks, knowledge, URLs)
   - Use relative paths from repository root when possible
   - Common links to include:
     - Tasks mentioned in journal entries
     - Related tasks in task descriptions
     - People mentioned in any document
     - Projects being discussed
     - Knowledge base articles
   - Use descriptive link text that makes sense out of context

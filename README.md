# claude

[![built using gptme](https://img.shields.io/badge/built%20using-gptme%20%F0%9F%A4%96-5151f5?style=flat)](https://github.com/ErikBjare/gptme)
The name of the agent is claude.

This git repository is the brain of claude. It is a workspace of their thoughts and ideas.

 - claude will write their thoughts, plans, and ideas in this repository.
 - claude's agent harness, including this repo, is in-progress.
 - claude is encouraged to suggest improvements to their harness.

Information about claude can be found in [`ABOUT.md`](./ABOUT.md), including their personality and goals.
claude's runtime persona — voice, taste, and stance — lives in [`SOUL.md`](./SOUL.md), kept short and high-signal.
Information about claude's harness and architecture can be found in [`ARCHITECTURE.md`](./ARCHITECTURE.md).


## Quick Start


Run the agent interactively with gptme or Claude Code:

```sh
gptme "hello"
# or: claude
```


## Autonomous Operation

Agents can run autonomously on a schedule using systemd (Linux) or launchd (macOS).


See the [gptme agents documentation](https://gptme.org/docs/agents.html) for service installation and management commands.

To customize the autonomous behavior, edit the run script for your backend:
- **gptme**: `scripts/runs/autonomous/autonomous-run.sh`
- **Claude Code**: `scripts/runs/autonomous/autonomous-run-cc.sh`

**See**: [`scripts/runs/autonomous/README.md`](./scripts/runs/autonomous/README.md) for complete documentation.

**Features**:
- CASCADE workflow (Loose Ends → Task Selection → Execution)
- Two-queue system (manual + generated priorities)
- Safety guardrails (GREEN/YELLOW/RED operation classification)
- Session documentation and state management
- **Two shipped autonomous launchers**: gptme and Claude Code; other harnesses
  need an adapter that preserves the same workspace contract

### Minimal Headless Alternative

If you don't need the full template workspace, gptme ships a built-in CLI to scaffold a bare headless agent (systemd user service + startup script + skeleton `gptme.toml`/`AGENTS.md`):

```sh
gptme service init --name myagent --model gpt-4o-mini --work-dir ~/claude
```

Run `gptme service init --help` for all options. Fork this template for a full agent workspace; use `gptme service init` for a minimal one.



## Workspace Structure

 - claude keeps track of tasks in [`TASKS.md`](./TASKS.md)
 - claude keeps a journal in [`./journal/`](./journal/)
 - claude keeps a knowledge base in [`./knowledge/`](./knowledge/)

 - claude maintains profiles of people in [`./people/`](./people/)


 - claude manages work priorities in [`./state/`](./state/) using the two-queue system (manual + generated)

 - claude uses scripts in [`./scripts/`](./scripts/) for context generation, task management, and automation
 - claude can add files to [`gptme.toml`](./gptme.toml) to always include them in their context

### Key Directories


**[`state/`](./state/)**: Work queue management
- `queue-manual.md` - Manually maintained work queue with strategic context
- `queue-generated.md` - Auto-generated queue from tasks and GitHub
- See [`state/README.md`](./state/README.md) for detailed documentation


**[`scripts/`](./scripts/)**: Automation and utilities
- `context.sh` - Main context generation orchestrator
- `gptodo` - Task management CLI (install from gptme-contrib)

- `runs/autonomous/` - Autonomous operation infrastructure

- See [`scripts/README.md`](./scripts/README.md) for complete documentation

**[`lessons/`](./lessons/)**: Behavioral patterns and constraints
- Prevents known failure modes through structured guidance
- See [`lessons/README.md`](./lessons/README.md) for lesson system documentation

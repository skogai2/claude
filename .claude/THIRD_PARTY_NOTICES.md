# Third-party notices

`commands/`, `skills/{task-management,lessons,autonomous-run}/`, and
`hooks/validate_task.py` are adapted from
[gptme/agent-workspace-plugin](https://github.com/gptme/agent-workspace-plugin)
(MIT License, Superuser Labs), with hook wiring changed from
`${CLAUDE_PLUGIN_ROOT}` to `$CLAUDE_PROJECT_DIR` for a project-local (rather
than globally installed) plugin.

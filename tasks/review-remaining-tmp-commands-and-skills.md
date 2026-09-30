---
state: backlog
created: 2026-09-30T13:14:44.367784+00:00
priority: medium
task_type: project
assigned_to: bob
tags: ["tmp", "review"]
---

# Review remaining tmp/ commands and skills

Not yet reviewed from tmp/ (examples from other gptme setups):

- tmp/commands/workspace-init.md, tmp/commands/workspace-status.md
  (from the retired agent-workspace-plugin — check if still useful
  or fully superseded by the real template's own tooling)
- tmp/skills/gptme-context, tmp/skills/gptme-review, tmp/skills/gptme-run
  (gptme-cc-plugin — skills that shell out to a real `gptme` CLI
  subprocess; gptme itself is installed at ~/.local/bin/gptme)
- tmp/skills/persistent-learning, tmp/skills/code-review,
  tmp/skills/git-workflow (gptme-skills-cc, standalone, no gptme
  dependency)
- tmp/skills/progressive-disclosure — duplicate of the one now
  symlinked at .claude/skills/progressive-disclosure (from
  gptme-contrib). Compare the two before adopting either; don't end
  up with two conflicting versions.

See journal/2026-09-30/gptme-agent-template-adoption.md for context.

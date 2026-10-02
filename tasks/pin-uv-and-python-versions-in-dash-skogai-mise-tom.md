---
state: backlog
created: 2026-10-02T15:05:56.356692+00:00
priority: medium
task_type: action
assigned_to: bob
tags: ["dash-skogai", "reproducibility"]
---

# Pin uv and python versions in dash-skogai mise.toml

mise.toml uses `uv = "latest"` and `python = "latest"`, while the rest of PR #1 pins carefully (gptme==0.34.0, contrib SHA). A fresh install can differ from what was tested.

- [ ] Choose versions (what the author tested in the clean-env run; python 3.14.x was system python here).
- [ ] Decide on a bump policy (manual with the contrib bump?).

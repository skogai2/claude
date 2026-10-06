# Projects

Projects this agent works with, each registered as a git submodule.

Submodules are **lazy by default**: they stay uninitialized (no working tree) until needed. Their commit is pinned in this repo's `.gitmodules` and index.

## Commands

```sh
scripts/project.sh status          # which projects are checked out
scripts/project.sh add NAME URL    # register a new project (left deinitialized)
scripts/project.sh init NAME       # check out a project when working on it
scripts/project.sh deinit NAME     # remove the working tree again
```

## Workflow

- Check a project out before working in it, and deinit it when done.
- For PR work, follow [`gptme-contrib/lessons/workflow/branch-from-master.md`](../gptme-contrib/lessons/workflow/branch-from-master.md): branch from `origin/master` and push with an explicit refspec.
- Bumping a project's pinned commit is a normal commit in this repo.

## Registered projects

| Path | Repo | Notes |
|------|------|-------|
| `projects/gptme` | https://github.com/gptme/gptme | Used by `harm_detect` in gptme-contrib (expects it checked out) |

`gptme-contrib` is not in this list: it is always initialized because skills and lessons depend on it.

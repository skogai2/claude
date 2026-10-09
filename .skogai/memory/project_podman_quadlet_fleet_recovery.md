---
name: project-podman-quadlet-fleet-recovery
description: "Status of recreating the stateless podman quadlet fleet (~/.config/containers/systemd) after the 2026-10-07 podman wipe, plus an open credential leak found during recovery"
metadata:
  node_type: memory
  type: project
  originSessionId: 757d066e-4595-4df8-b8b9-98481d95e31d
  modified: 2026-10-08T23:29:47.006Z
---

The `~/.config/containers/systemd` repo (gita name `podman`) lost all podman
state — secrets, volumes, and the `~/.local/src/*` source checkouts its
`.build` units depend on — when Omarchy's Docker defaults displaced podman on
`skogix-workstation` (discovered 2026-10-07, documented in the repo's
`SECRETS.md` and `PLAN.md`).

As of 2026-10-09: `skogai-tunnel`, `termix`, `termix-guacd`, `mcphub`,
`basic-memory`, and `agentchattr` are active again. Re-cloned the missing
source checkouts from `skogai/skogchattr`, `skogai/basic-memory`,
`skogai/paperclip` on GitHub, and recreated every secret that doesn't need an
external dashboard (fresh `openssl rand -hex 32` values and Postgres
passwords for mcphub/basic-memory/paperclip/agentchattr). Still open:
`pangolin-site.env` (needs Pangolin dashboard values), `agentbot/config.toml`
and the `agentbot-claude-token` podman secret (need Emil's own input —
Delta Chat address, `claude setup-token`), and `paperclip.service` (build
fails on an upstream `pnpm-lock.yaml` overrides mismatch in the
`skogai/paperclip` repo itself, not a secrets problem). `skognet-dns` is
stopped, not fixed — it wants to bind `10.10.4.5:53` but the host's current
DHCP lease on `enp0s31f6` is `10.10.4.3`; needs either a DHCP reservation for
`.5` or updating the Tailscale split-DNS config + quadlet to the new IP.

**Security finding, unresolved as of 2026-10-09:** the public GitHub repo
`skogai/skogchattr`'s `skogai` branch has a committed
`.container-home/claude/.credentials.json` containing a live Claude OAuth
access/refresh token pair. Flagged to Emil, not fixed. Treat as compromised
until revoked and the branch history is scrubbed or the repo made private.
[[project_global_git_hooks_landmine]] is a separate but similarly-flavored
"secrets/history landmine in a skogai repo" issue worth cross-checking when
touching other skogai forks.

**Why this matters:** any future session touching this repo should re-check
`bin/quadlet-health` rather than assume past state, and should not treat
`SECRETS.md`'s "Not yet" rows as still accurate without re-reading it — this
status moves fast and gets updated in-place in the repo, not just here.

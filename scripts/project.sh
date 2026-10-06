#!/usr/bin/env bash

# project.sh — Manage projects under projects/ as lazily checked-out submodules
#
# Projects are registered as submodules but stay uninitialized (no working tree)
# until needed. The submodule commit stays pinned in this repo.
#
# Usage:
#   ./scripts/project.sh status              # list projects and checkout state
#   ./scripts/project.sh add NAME URL        # register a new project (leaves it deinitialized)
#   ./scripts/project.sh init NAME           # check out a project when you need it
#   ./scripts/project.sh deinit NAME         # remove the working tree again (keeps the cached clone)

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

usage() {
    sed -n '3,12p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
    exit "${1:-0}"
}

path_for() {
    local name="$1"
    if [ -z "$name" ] || [[ "$name" == */* ]]; then
        echo "error: project name must be a single path segment: '$name'" >&2
        exit 1
    fi
    echo "projects/$name"
}

cmd_status() {
    if [ ! -f .gitmodules ] || ! grep -q '^\[submodule "projects/' .gitmodules; then
        echo "no projects registered"
        return
    fi
    # submodule status prefix: '-' = uninitialized, ' ' = checked out, '+' = differs from pin
    git submodule status -- projects/ | while read -r first path _; do
        case "${first:0:1}" in
            -) state="deinitialized" ;;
            +) state="checked out (differs from pin)" ;;
            U) state="merge conflict" ;;
            *) state="checked out" ;;
        esac
        echo "$path  $state"
    done
}

cmd_add() {
    local name="${1:-}" url="${2:-}"
    [ -n "$url" ] || { echo "error: usage: add NAME URL" >&2; exit 1; }
    local path
    path="$(path_for "$name")"
    [ ! -e "$path" ] || { echo "error: $path already exists" >&2; exit 1; }
    # git submodule add clones the repo; deinit right after so it stays lazy.
    git submodule add "$url" "$path"
    git submodule deinit -f -- "$path" >/dev/null
    echo "added $path (deinitialized). Check it out with: $0 init $name"
}

cmd_init() {
    local path
    path="$(path_for "${1:-}")"
    git submodule update --init -- "$path"
    echo "checked out $path"
}

cmd_deinit() {
    local path
    path="$(path_for "${1:-}")"
    git submodule deinit -f -- "$path"
    echo "deinitialized $path"
}

case "${1:-}" in
    status) cmd_status ;;
    add) shift; cmd_add "$@" ;;
    init) shift; cmd_init "$@" ;;
    deinit) shift; cmd_deinit "$@" ;;
    -h|--help|help|"") usage 0 ;;
    *) echo "error: unknown command: $1" >&2; usage 1 ;;
esac

#!/usr/bin/env bash
# Generate layer 0 — docs/context/tools.md — from the live skills' own frontmatter.
#
# SYS-013 confines layer 0 to tool selection and delegation: which tool, and what
# for. BLD-014 makes it GENERATED rather than written, so that confinement is
# structural instead of promised — anything smuggled in does not survive the next
# run, and check 13 fails the build when the committed file differs from a fresh
# generation.
#
# The one-line purpose is each skill's own `description`, copied verbatim. A
# summary written here would be interpretation, and interpretation at layer 0 is
# contamination with extra steps.
#
# The footer count is incremented by the emitting loop, so it counts exactly what
# the table lists. It previously globbed skills/*/ separately, which disagreed with
# the loop whenever a directory had no SKILL.md -- the empty shell a deprecation
# strands behind (see skills/deprecated/README.md) made check 13 report drift that
# was not drift. One traversal, one count.
#
# Usage: scripts/gen-tools-index.sh [--check] [--project DIR]
#   (no args)   write DIR/docs/context/tools.md
#   --check     print the generation to stdout and write nothing
#   --project   which project to generate FOR. Defaults to $PWD.
#
# --project exists because this script is shared, not copied. ADR-0003 makes a run
# a project with its own layer 0, and a run reaches this script through a link to
# the harness's copy. Until 2026-08-25 the script opened with
# `cd "$(dirname "$0")/.."`, which resolves to the HARNESS root no matter where it
# was invoked from — so generating layer 0 for a run silently rewrote the harness's
# own tools.md instead. It reads skills from its own repo (one fork, one skill set,
# per BLD-015) and writes into the project it was pointed at.

set -uo pipefail

# readlink -f, not dirname alone: in a scaffolded project this script is reached
# through a SYMLINK into archive/scripts/. dirname "$0" would give the project's
# own scripts/ and resolve the harness root to the project, which globs no skills
# and silently emits an empty tool table — a layer 0 with nothing in it.
_self="$(readlink -f "$0" 2>/dev/null || echo "$0")"
HARNESS_ROOT="$(cd "$(dirname "$_self")/.." && pwd)"
PROJECT_ROOT="$PWD"
ARGS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --project) PROJECT_ROOT="$(cd "${2:-.}" && pwd)"; shift ;;
    *)         ARGS+=("$1") ;;
  esac
  shift
done
set -- "${ARGS[@]+"${ARGS[@]}"}"

# Skills are read from the harness; the index is written into the project.
cd "$HARNESS_ROOT" || exit 1

emit() {
  cat <<'HEADER'
# Layer 0 — tools

**Generated. Do not edit.** Run `scripts/gen-tools-index.sh`; check 13 fails the build if this
file and a fresh generation differ.

Which tool, and what for. Nothing else belongs here — not what the system does, not how any tool
works, not a route from a question to an answer. See
[`architect-mode/context-layers.md`](../agents/architect-mode/context-layers.md) for why layer 0
is orthogonal to the derivation chain rather than above it, and `SYS-013` for the confinement.

A tool's operating detail is loaded on demand by a subagent and never retained here.

| Tool | Invocation | What for |
| --- | --- | --- |
HEADER

  n=0
  for d in skills/*/; do
    s=$(basename "$d")
    [ "$s" = "deprecated" ] && continue
    f="skills/$s/SKILL.md"
    [ -f "$f" ] || continue

    # description: may be quoted, may run to end of line. Frontmatter only.
    desc=$(awk '
      NR==1 && /^---/ {fm=1; next}
      fm && /^---/ {exit}
      fm && /^description:/ {
        sub(/^description:[ \t]*/, "")
        gsub(/^"|"$/, "")
        print
        exit
      }
    ' "$f")

    if grep -q '^disable-model-invocation: true' "$f"; then
      mode="user only"
    else
      mode="model or user"
    fi

    printf '| `/%s` | %s | %s |\n' "$s" "$mode" "$desc"
    n=$((n + 1))
  done

  printf '\n%s\n' "_${n} tools. Retired skills live in \`skills/deprecated/\` and are not listed: they are not loaded, so they are not selectable._"
}

if [ "${1:-}" = "--check" ]; then
  emit
else
  mkdir -p "$PROJECT_ROOT/docs/context" && emit > "$PROJECT_ROOT/docs/context/tools.md"
  echo "wrote $PROJECT_ROOT/docs/context/tools.md"
fi

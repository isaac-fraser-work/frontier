#!/usr/bin/env bash
#
# Layer 0 generator — thin resolver.
#
# The real generator reads the skills' own frontmatter, so it has to run from
# where the skills are. Under a plugin install that is Claude Code's plugin cache,
# not this project, and the cache path carries a version segment that changes on
# every upgrade. Hardcoding it here would rot at the next `claude plugin update`.
#
# So: resolve the harness at run time, then exec the real generator against this
# project. Fails loudly — an unresolved harness must never silently emit an empty
# tool table, because check 13 would then compare one empty table against another
# and pass while layer 0 says nothing.
#
# Usage: scripts/gen-tools-index.sh [--check]
#   (no args)   write docs/context/tools.md
#   --check     print the generation to stdout and write nothing
#
# Override with FRONTIER_ROOT=/path/to/frontier if you run the harness from a clone.

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

usable() { [[ -n "${1:-}" && -d "$1/skills" && -x "$1/scripts/gen-tools-index.sh" ]]; }

resolve() {
  local c
  # 1. explicit override, 2. set by Claude Code inside a plugin command
  for c in "${FRONTIER_ROOT:-}" "${CLAUDE_PLUGIN_ROOT:-}"; do
    usable "$c" && { printf '%s' "$c"; return 0; }
  done
  # 3. the installed-plugin registry — authoritative, and version-agnostic
  local reg="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/plugins/installed_plugins.json"
  if [[ -r "$reg" ]] && command -v python3 >/dev/null 2>&1; then
    c="$(python3 - "$reg" <<'PY' 2>/dev/null || true
import json, sys
try:
    reg = json.load(open(sys.argv[1])).get("plugins", {})
except Exception:
    sys.exit(0)
for key, entries in reg.items():
    if key.split("@")[0] != "frontier":
        continue
    for e in entries:
        p = e.get("installPath")
        if p:
            print(p)
            sys.exit(0)
PY
)"
    usable "$c" && { printf '%s' "$c"; return 0; }
  fi
  # 4. the marketplace clone
  c="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/plugins/marketplaces/frontier"
  usable "$c" && { printf '%s' "$c"; return 0; }
  return 1
}

if ! ROOT="$(resolve)"; then
  cat >&2 <<'ERR'
error: cannot locate the frontier harness, so layer 0 cannot be generated.

  The generator needs the skills, which live with the plugin. Either:
    claude plugin install frontier@frontier
  or, if you run the harness from a clone:
    FRONTIER_ROOT=/path/to/frontier scripts/gen-tools-index.sh
ERR
  exit 1
fi

exec "$ROOT/scripts/gen-tools-index.sh" --project "$PROJECT_ROOT" "$@"

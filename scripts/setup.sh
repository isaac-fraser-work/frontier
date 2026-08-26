#!/usr/bin/env bash
#
# frontier-setup — wire the current directory to the frontier harness.
#
# Writes the architect-mode contract, the docs/agents reference layer, the
# context-layer skeleton and a rendered CLAUDE.md / RUN.md into $PWD.
#
#   --name NAME     project name          (default: directory name)
#   --prefix PFX    id prefix for this run (default: NAME, uppercased)
#   --repo SLUG     owner/repo for the tracker doc (default: git origin, else OWNER/REPO)
#   --force         overwrite files that already exist
#
# Idempotent by default: an existing file is kept, never clobbered. Nothing here
# touches the network, installs anything, or writes outside $PWD.

set -euo pipefail

NAME=""; PREFIX=""; SLUG=""; FORCE=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --name)   NAME="${2:-}";   shift 2 ;;
    --prefix) PREFIX="${2:-}"; shift 2 ;;
    --repo)   SLUG="${2:-}";   shift 2 ;;
    --force)  FORCE=1;         shift ;;
    -h|--help) sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) printf 'unknown option: %s\n' "$1" >&2; exit 2 ;;
  esac
done

# CLAUDE_PLUGIN_ROOT is set when this runs as a plugin command. Fall back to the
# repo root so the script also works from a plain git clone.
ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
TEMPLATE="$ROOT/template"
[[ -d "$TEMPLATE" ]] || { printf 'error: no template/ at %s\n' "$ROOT" >&2; exit 1; }

NAME="${NAME:-$(basename "$PWD")}"
if [[ -z "$PREFIX" ]]; then
  # Uppercase, non-alnum folded to a hyphen, leading/trailing hyphens trimmed.
  PREFIX="$(printf '%s' "$NAME" | tr '[:lower:]' '[:upper:]' | tr -c 'A-Z0-9' '-' )"
  PREFIX="${PREFIX##-}"; PREFIX="${PREFIX%%-}"
fi
if [[ -z "$SLUG" ]] && URL="$(git remote get-url origin 2>/dev/null)"; then
  URL="${URL%.git}"
  case "$URL" in
    *://*) SLUG="$(printf '%s' "${URL#*://}" | cut -d/ -f2-)" ;;
    *:*)   SLUG="${URL##*:}" ;;
  esac
fi
SLUG="${SLUG:-OWNER/REPO}"
DATE="$(date -u +%Y-%m-%d)"
HARNESS_URL="https://github.com/isaac-fraser-work/frontier/blob/main"

info() { printf '  %s\n' "$*"; }

# Renders {{PLACEHOLDER}}s from $1 into $2. Keeps an existing $2 unless --force.
render() {
  local src="$1" dst="$2"
  if [[ -e "$dst" && "$FORCE" -eq 0 ]]; then info "kept   $dst"; return 0; fi
  mkdir -p "$(dirname "$dst")"
  sed -e "s|{{PROJECT_NAME}}|$NAME|g" \
      -e "s|{{RUN_PREFIX}}|$PREFIX|g" \
      -e "s|{{REPO_SLUG}}|$SLUG|g" \
      -e "s|{{FRONTIER_REPO}}|$HARNESS_URL|g" \
      -e "s|{{DATE}}|$DATE|g" \
      "$src" > "$dst"
  info "wrote  $dst"
}

printf '\n\033[1m▸ frontier — scaffolding %s\033[0m\n' "$NAME"
info "prefix $PREFIX-   repo $SLUG"

# docs/agents — the contract and its reference layers. One real copy lives at the
# harness root, which is the path every skill cites. Rendered into the project, not
# linked: a plugin's install directory is a cache and may be replaced underneath it.
while IFS= read -r rel; do
  render "$ROOT/docs/agents/$rel" "docs/agents/$rel"
done < <(cd "$ROOT/docs/agents" && find . -name '*.md' -printf '%P\n' | sort)

# scripts — the conformance checks, shipped with the doctrine.
for s in "$TEMPLATE"/scripts/*.sh; do
  dst="scripts/$(basename "$s")"
  if [[ -e "$dst" && "$FORCE" -eq 0 ]]; then info "kept   $dst"; continue; fi
  mkdir -p scripts && cp "$s" "$dst" && chmod +x "$dst" && info "wrote  $dst"
done

# The shape exists before anything fills it.
for d in docs/context docs/adr docs/observations artefacts; do
  mkdir -p "$d"; [[ -e "$d/.gitkeep" ]] || { : > "$d/.gitkeep"; info "mkdir  $d/"; }
done

# Layer 0 is GENERATED, never hand-authored (BLD-014), so it is rewritten on every
# run regardless of --force. The generator reads skills from its own parent, which
# is why it lives at the plugin root next to skills/ and not in the project.
if [[ -x "$ROOT/scripts/gen-tools-index.sh" ]]; then
  "$ROOT/scripts/gen-tools-index.sh" --project "$PWD" >/dev/null \
    && info "gen    docs/context/tools.md (layer 0)"
fi

render "$TEMPLATE/CLAUDE.md"             CLAUDE.md
render "$TEMPLATE/RUN.md"                RUN.md
render "$TEMPLATE/gitignore"             .gitignore
render "$TEMPLATE/claude-settings.json"  .claude/settings.json

# CONTEXT.md is deliberately absent — SYS-004: the architect alone defines that
# layer, and a template would be an agent's first draft of it. /context writes it.

printf '\n\033[1m▸ done\033[0m\n'
info "16 skills available from the plugin; contract at docs/agents/architect-mode.md"
info "CONTEXT.md is not scaffolded on purpose — /context writes it from what you decide"
info ""
info "next:  claude  then  /ring"

# frontier — the harness itself

This repo is the **distribution** of the frontier harness: a Claude Code plugin. It is not a
project scaffolded *with* the harness, and it does not carry its own derivation chain. Work
here is maintenance of the tools, not a run.

For what the harness is and how to install it, see [README.md](README.md).

## Layout

| Path | What |
| --- | --- |
| `.claude-plugin/` | `plugin.json` and `marketplace.json` — the manifests Claude Code reads |
| `skills/` | The 16 live skills. Retired ones stay in the private workshop, not here |
| `commands/setup.md` | `/frontier:setup` — the scaffolder's slash command |
| `scripts/setup.sh` | The scaffolder. Writes a project's contract and context skeleton |
| `scripts/gen-tools-index.sh` | Layer-0 generator. Reads skills from **this** repo root |
| `docs/agents/` | The contract. **One real copy**, at the path every skill cites |
| `docs/context/tools.md` | This repo's own layer 0, generated |
| `template/` | The per-project files: `CLAUDE.md`, `RUN.md`, gitignore, settings, scripts |
| `docs/adr/` | Architecture decision records for the harness's own design |

`docs/agents/` is **not** under `template/`. Every skill cites it as `docs/agents/...`
relative to the project root, and that same path has to resolve here or check 15 fails on
the harness. One copy, at the root, rendered into each project by `setup.sh`.

## Two copies of the layer-0 generator, on purpose

`scripts/gen-tools-index.sh` is the real one: it resolves its skills from its own parent
directory, which here is the repo root, where `skills/` lives.

`template/scripts/gen-tools-index.sh` is a **resolver** that ships into projects. A project
has no `skills/` — they live in the plugin cache under a versioned path that changes on
every `claude plugin update` — so the shipped copy locates the harness at run time
(`FRONTIER_ROOT`, then `CLAUDE_PLUGIN_ROOT`, then `installed_plugins.json`, then the
marketplace clone) and execs the real one. It fails loudly rather than emitting an empty
tool table, because an empty table would let check 13 compare nothing against nothing and
pass.

## Changing a skill

Edit under `skills/`. Then bump `version` in `.claude-plugin/plugin.json` — installs are
pinned per version, so an unbumped change does not reach anyone who has already installed.

Layer 0 in every downstream project regenerates itself from skill frontmatter, so a changed
`description:` propagates on the next `/frontier:setup` or `scripts/gen-tools-index.sh`.

## Verifying a change

```bash
scripts/check-architect-mode.sh          # all 16 checks, harness-side
```

And end to end, against a throwaway directory:

```bash
d=$(mktemp -d) && (cd "$d" && git init -q -b main \
  && FRONTIER_ROOT=$PWD bash "$OLDPWD/scripts/setup.sh" --name probe \
  && bash scripts/check-architect-mode.sh)
```

## How every response ends

**`SYS-011`.** Unless the work is *finished* — finished, not merely blocked — close every
response with these four, in order:

1. **Quick context** — where things stand, in the fewest words that still orient.
2. **What is required** — the actual next operation. Not options.
3. **What is recommended** — what should happen, where that differs from what must.
4. **Why** — the reason the recommendation is what it is.

## Decisions put to the architect are numbered

**`SYS-014`.** Every decision put to the architect carries an **explicit number**, and the
numbering **resets at each decision fork** rather than running on through the session.

## Git operations are bookkeeping

**`BLD-017`.** Branching, staging, committing, pushing, opening a pull request, merging and
deleting a merged branch are **mechanical steps in closing work**, not decisions. Perform
them unasked and report what was done.

The split is **content versus carriage**: carriage is the agent's, content is the architect's.

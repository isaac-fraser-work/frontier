# frontier

An agent harness for [Claude Code](https://claude.com/claude-code), built on **derived context**.

The architect authors what the system is for. Every layer below it is *derived* from that,
never authored upward — and an agent that wants to decide something the layer above it
does not settle has to escalate rather than guess. Sixteen skills run on top of that
contract, and `/ring` is the only way in.

```
claude plugin marketplace add isaac-fraser-work/frontier
claude plugin install frontier@frontier
```

Then, in any project directory:

```
/frontier:setup
```

That is the whole install. The rest of this file explains what those three lines do.

---

## Install

### 1. Add the marketplace

```bash
claude plugin marketplace add isaac-fraser-work/frontier
```

Clones this repo to `~/.claude/plugins/marketplaces/frontier` and registers it. Nothing is
enabled yet.

### 2. Install the plugin

```bash
claude plugin install frontier@frontier
```

Installs at **user scope** by default, so the skills are available in every project. Use
`--scope project` to confine it to the current repo.

Both commands also work from inside a session as `/plugin marketplace add …` and
`/plugin install …`, or interactively through `/plugin`.

### 3. Wire a project

```bash
cd ~/projects/whatever
claude
```
```
/frontier:setup
```

`/frontier:setup` writes the contract and the context-layer skeleton into the current
directory:

```
CLAUDE.md              the rules that bind before any skill fires
RUN.md                 this run's id prefix and its layers
docs/agents/           the architect-mode contract + its reference layers
docs/context/tools.md  layer 0 — generated from the skills' frontmatter
docs/context/          layers 2 and 3 land here as they are written
docs/adr/              architecture decision records
artefacts/             what this run produced
scripts/               the conformance checks
.claude/settings.json  sandbox + permissions defaults
```

It is **idempotent** — an existing file is kept, never clobbered, unless you pass
`--force`. It touches no network and writes nothing outside the current directory.

```
/frontier:setup --name my-app --prefix APP --repo owner/my-app
```

| Flag | Default |
| --- | --- |
| `--name` | the directory name |
| `--prefix` | the name, uppercased — ids become `APP-001`, `APP-BLD-001` |
| `--repo` | parsed from `git remote get-url origin` |
| `--force` | off; pass it to overwrite existing files |

### 4. Start

```
/ring
```

`/ring` is the entry point and the top-level driver. It works out what you need, picks the
tool, and hands the job to an agent that runs it. You are not meant to reach for the other
fifteen skills directly.

> **`CONTEXT.md` is deliberately not scaffolded.** That layer is the architect's alone, and
> a template would be an agent's first draft of it. It is created by the first entry
> `/context` writes. Until it exists there is nothing for the derivation chain to derive
> from, so run `/context` before `/ring`.

---

## What you get

### The context layers

| Layer | File | What it holds |
| --- | --- | --- |
| **0 — tools** | `docs/context/tools.md` | Which tool, what for. Generated from the skills, never edited |
| **1 — actual** | `CONTEXT.md` | What the system is for. **The architect's alone** |
| **2 — build** | `docs/context/build.md` | How it is built to fulfil layer 1 |
| **3 — working** | `docs/context/working.md` | What the code does now, and the open wave |

Layer 0 is orthogonal to the other three rather than above them: layers 1–3 describe the
system being built, layer 0 describes the tools that build it.

The tiers are strictly derived. An agent may *transcribe* a decision the architect has
taken, but only with their own words quoted verbatim beside it. **A layer is never authored
from below.**

### The skills

| Tool | What for |
| --- | --- |
| `/ring` | The way in. Picks the tool and hands the job to an agent that runs it |
| `/context` | Interviews the architect and records what they decide, quoted |
| `/frontier-control` | Holds build context, derives units of work, dispatches subagents |
| `/audit` | Audits system context an agent decided in your absence |
| `/courier` | Answers what another run established, without either holding the other's context |
| `/implement` | Builds a unit of work against its build entry |
| `/tdd` | Red–green–refactor, integration-first |
| `/code-review` | Reviews a range on two axes — standards and spec — in parallel |
| `/codebase-design` | Deep-module vocabulary: interfaces, seams, deepening opportunities |
| `/diagnosing-bugs` | Diagnosis loop for hard bugs and performance regressions |
| `/domain-modeling` | Ubiquitous language and architecture decision records |
| `/grilling` | Stress-tests a plan or decision, relentlessly |
| `/grill-with-docs` | The same, with primary sources in hand |
| `/prototype` | Throwaway prototype to answer one design question |
| `/research` | Investigates against high-trust sources, writes findings to the repo |
| `/resolving-merge-conflicts` | Works an in-progress merge or rebase |

Installed as a plugin, these are namespaced — `/frontier:ring`, `/frontier:context`, and so
on. The bare forms above are how the contract cites them.

### Work entry

**Nothing arrives from outside the derivation.** Every unit of work comes from a `BLD-`
entry, which comes from a `SYS-` entry the architect wrote. Units live in
`docs/context/working.md`, never on an issue tracker. The tracker stays enabled — the repo
still has pull requests — but it is capability, never a place work goes.

---

## Running it from a clone

The plugin is the supported path. If you would rather work from a checkout:

```bash
git clone https://github.com/isaac-fraser-work/frontier.git ~/src/frontier
cd ~/projects/whatever
FRONTIER_ROOT=~/src/frontier bash ~/src/frontier/scripts/setup.sh
ln -s ~/src/frontier/skills .claude/skills
```

`FRONTIER_ROOT` is what the layer-0 generator resolves against when
`CLAUDE_PLUGIN_ROOT` isn't set.

## Checking conformance

```bash
scripts/check-architect-mode.sh
```

Sixteen checks. In a project the skill-set checks (1–9) are skipped — they belong to the
harness — and the rest run against your own layers: every cited id resolves, every entry
carries a verbatim record, layer 0 matches a fresh generation, every repo-relative path a
doc cites exists.

## A note on other skill plugins

Nine of these skills are forks of [`mattpocock/skills`](https://github.com/mattpocock/skills),
and both sets are model-invoked. With both installed the model picks between two versions of
the same skill unpredictably. The scaffolded `.claude/settings.json` disables the upstream
plugin **in that project only**; it stays available everywhere else.

## Licence

MIT — see [LICENSE](LICENSE). The forked skills carry their upstream MIT licence.

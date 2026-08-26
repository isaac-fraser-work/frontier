# A run is a project; runs are parallel peers

**Status:** accepted.

*Derives from `SYS-004`, `SYS-007`, `SYS-010`, `SYS-013`, `SYS-015`, `BLD-015`, `BLD-016`,
`BLD-019`, and [`ADR-0002`](0002-work-entry-model.md).*

`SYS-007` recorded, and did not pursue, what happens when the harness is pointed at something
other than itself: *"that project takes its own `CONTEXT.md` and this one stays the harness's —
noted so the two are not collapsed later."* `BLD-015` cited that note as settled and scaffolded
arbitrary directories on the strength of it. The note was marked **"Nothing live."** This ADR
resolves what it parked, and corrects the reading `BLD-015` took of it.

## Decision

### What a run is

**One `/ring` invocation is one project.** It holds a complete derivation chain — its own
`CONTEXT.md`, its own build context, its own working context, its own artefacts — inside its own
directory. The architect, verbatim:

> I want each ring level0 (user context - ring (or clanker when done)) to hold its own dir. one
> folder within for each tier, work from there. therefore I can run as many rings as i want and
> they can all accurately derive system context from others. so basically spawns its own file
> system wihin the project.

`CONTEXT.md` is **per run**. ~~Ring does not author it; it transcribes the architect's answers
under `SYS-010`.~~ **Struck 2026-08-25 by the architect.** `ring:71` forbids ring writing
`CONTEXT.md` *"not through a tool, not by asking one to, by any route"*, and `SYS-004` is
unconditional — the first draft reconciled the two by calling ring's write a transcription, which
is the distinction `ring:71`'s "by any route" exists to refuse.

**What replaces it.** Ring writes `CONTEXT.md` by no route at all. It **operates `/context` in
place**, and `/context` transcribes. The architect settled the rule that permits this separately
and it is recorded in [`docs/observations/0002-preflight-audit.md`](../observations/0002-preflight-audit.md)
pending transcription into layer 1 — ring may not write that layer, including the entry that
authorises ring.

**Not yet executable.** `/context` carries `disable-model-invocation: true`, so ring cannot invoke
it. The unit that changes this writes `skills/` and is blocked under `BLD-016`.

The architect's original words, which the struck mechanism was reaching for and got wrong:

> Im not manually writing CONTEXT.md every run, i get ring to write it by interrogating me, so it
> is per ring.

`context-layers.md` gives actual system context the lifetime *"Durable — outlives every build."*
That holds unchanged, at the scope it was written for. The architect, verbatim:

> "durable - outlives every build" is still true WITHIN THAT PROJECT, just happens said project is
> part of a collection of projects building to a system

### The layout

```
runs/
  0001-<slug>/
    CONTEXT.md                    actual  — this run's, transcribed by ring
    RUN.md                        prefix, invocation, status
    docs/
      agents/      -> symlink     the contract, one copy, never re-authored
      context/tools.md            layer 0 — regenerated at run start (SYS-015)
      context/build.md            build   — this run's
      context/working.md          working — this run's
      adr/
      observations.md             verbatim architect log for this run
    artefacts/                    deliverables
    .claude/skills -> harness     tools
  0002-<slug>/                    the same shape, again
```

Each run is what `bin/claude-init-frontier` already produces: `PROJECT_DIR="$PWD"` means the
scaffolder builds whatever directory it is standing in. A run directory is not a new kind of
object.

### Runs are parallel, not hierarchical

There is no parent run, no child run, no inheritance and no import list. The architect, verbatim:

> YOU SHOULD FRAME THESE RUNS NOT AS HIERARCHICAL, THINK OF EM AS PARALLEL OPERATIONS

A new run inherits **nothing**. It is interrogated from scratch and the cost of re-answering is
accepted, on the same grounds `SYS-015` accepts the cost of regenerating layer 0: a chain that
starts fresh cannot start stale.

**The harness is not a parent either.** It sits orthogonal to every run, the way layer 0 sits
orthogonal to layers 1–3 in `context-layers.md`: it supplies tools and holds no run's context.

**Two runs may hold contradictory actual system context, legitimately.** They are different
projects. With no hierarchy there is no tiebreak, and inventing one would make some run's layer 1
authoritative over another's — which is the collapse `SYS-007` said not to make.

### Crossing a boundary — `courier`

Runs are sealed. The only thing that crosses is a subagent spawned per query, which dies with its
answer. The architect, verbatim:

> there should be a tool that should be spawned as sub agent THAT IS ALLOWED and has knowlege of
> the structure so knows meaning of each layer, and that can be used to interface context.

| | |
| --- | --- |
| **Reads** | Any run's `CONTEXT.md`, `build.md`, `working.md`, `artefacts/` |
| **Writes** | Nothing, in any run, ever. `SYS-004` is untouched |
| **Returns** | A briefing, never a file — the discipline `/ring` already uses for tool interfaces |
| **Cites** | Run prefix and id on every fact, so each one is checkable at its source |
| **Knows** | The layer schema, and therefore what *kind* of claim a fact is |
| **Never** | Answers *what should X be*. Only *what does run Y say about X* |

**It is a lookup and may not route.** `/ring`'s body states the converse of itself — *"You route
work to tools. You are not a lookup."* Each tool is forbidden the other's job, which is what stops
either drifting into the other.

**It may read a run that is still open**, with the briefing marked volatile. Sealing open runs
from each other would make peers sequential in practice, which is the property this model exists
to provide.

**Conflicts are reported, never resolved.** Where two runs disagree, `courier` returns both
citations and escalates under `SYS-006`. Resolving would be an agent authoring layer 1 sideways.

### Ids carry a per-run prefix

Each run declares a prefix at init — `STAND-`, and so on — allocated once and globally unique
across `runs/`. `STAND-002` therefore names one entry in one run without qualification, which is
what makes a `courier` citation checkable.

This also settles a defect found before this ADR: `docs/agents/ids.md` instructs every project to
allocate `SYS-nnn` in its own `CONTEXT.md` while itself citing `SYS-001`…`SYS-013` as the
harness's entries. Two meanings, one namespace, in a file copied verbatim into every project. A
per-run prefix removes the collision at its source rather than renaming after the fact — which
`ids.md` forbids anyway, at *"Ids are never reused and never renumbered."*

### The contract is symlinked, not copied

`BLD-015` copies `docs/agents/` into each project so that skills, which reference it by
repo-relative path, resolve. The copied contract cites `SYS-001`…`SYS-013` — entries defined only
in the harness — and `BLD-015` deliberately does not scaffold `CONTEXT.md`. **Every scaffolded
project therefore begins with twelve dangling `SYS-` citations**, measured in the first one built.

A symlink satisfies the repo-relative path requirement without creating a second copy. `BLD-015`
rejected copying *skills* on exactly this reasoning — *"every project becomes a fork of the fork"*
— and did not apply it to the contract.

**Discovery is a directory listing** of `runs/`, with `RUN.md` inside each carrying its prefix and
status. No registry file: a registry is a second place the truth has to be maintained.

## Considered Options

- **Runs inherit from a declared parent, or from an import list in `RUN.md`.** Rejected by the
  architect. Inheritance makes one run's authority over another implicit, and the derivation chain
  across the collection stops being visible in any single place.
- **One `CONTEXT.md` per repository, runs holding only layers 0 and 3.** This ADR's first draft,
  and wrong: it read *"durable"* at repository scope when the scope that matters is the project,
  and a run is a project. It also left ring unable to transcribe, which is the interface the
  architect actually uses.
- **`courier` reads only closed runs.** Rejected: it reintroduces sequencing between operations
  that are meant to be parallel.
- **A registry file listing every run.** Rejected: `runs/` already lists them, and a registry
  drifts the moment one is added by hand.

## Consequences

- **Every run re-interrogates the architect.** Accepted cost of no inheritance. Where a run needs
  what another established, it asks `courier` rather than inheriting it.
- **`courier` cannot be built from an activated session.** It is a `SKILL.md`; `BLD-016` applies
  and `BLD-019` governs. Derived, marked undispatchable, parked.
- **`BLD-015`'s copy of the contract becomes a symlink**, which retires the dangling-citation
  defect for every future run and leaves existing scaffolded projects to be re-run.
- **The observations series already numbers per run** — `docs/observations/README.md`: *"One file
  per run: `NNNN-<slug>.md`."* Run directories take the same numbering, and the series continues
  rather than restarting.
- **Provenance becomes a path.** An artefact at `runs/0002-blueprint/artefacts/x.md` names the run
  that produced it by location, with no header to maintain and nothing to drift.

## Committed without asking

- Working name `courier` — the agent's, offered and not objected to. Not an architect decision;
  rename freely.
- The `0-tools`/`1-system` numbering of an earlier draft is dropped in favour of the layout
  `claude-init-frontier` already produces, so that a run directory and a scaffolded project are
  the same object rather than two shapes to keep in step.

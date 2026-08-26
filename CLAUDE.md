# frontier

One-line description of this project — replace me.

## Agent skills

### How every response ends

**`SYS-011`.** Unless the work is *finished* — finished, not merely blocked — close every
response with these four, in order:

1. **Quick context** — where things stand, in the fewest words that still orient.
2. **What is required** — the actual next operation. Not options.
3. **What is recommended** — what should happen, where that differs from what must.
4. **Why** — the reason the recommendation is what it is.

The architect must never have to ask *"what now?"* to retrieve state the system already
holds. This is stated here rather than pointed at because it governs every response at
every tier, including turns where no skill fires — which is the one thing a skill cannot do.

### Start here

Type **`/ring`**. It is the entry point and the top-level driver: it works out what you
need, picks the tool, and hands the job to an agent that runs it. Everything else is
reached through it.

### Architect mode

The standing contract for every agent in this repo, at all three scope tiers — architect,
controller, subagent. Governs which layer of context authorises a decision, how an
escalation moves between tiers, how decisions are recorded, and the shape of every
response. See `docs/agents/architect-mode.md`; role-specific protocol lives in
`docs/agents/architect-mode/`.

The tiers are strictly derived: the architect authors actual system context, the
controller derives build context from it, working context derives from that. **A layer is
never authored from below.** An agent may *transcribe* a decision the architect has taken,
but only with their own words quoted verbatim beside it. The one agent licensed to
*decide* any of it in their place is `clanker`, and only for a run the architect explicitly
invoked it for.

### Context layers

- **Layer 0** — `docs/context/tools.md`. Which tool, what for. Generated, never edited.
- **Layer 1** — `CONTEXT.md`. What the system is for. **The architect's alone.**
- **Layer 2** — `docs/context/build.md`. How it is built to fulfil layer 1.
- **Layer 3** — `docs/context/working.md`. What the code does now, and the open wave.

Layer 0 is orthogonal to the other three, not above them: layers 1-3 describe the system
being built, layer 0 describes the tools that build it. See `docs/agents/domain.md`.

### Work entry — no tracker

**Nothing arrives from outside the derivation.** Every unit of work comes from a `BLD-`
entry, which comes from a `SYS-` entry the architect wrote. Units live in
`docs/context/working.md`, never on an issue tracker.

### Forked skills

`.claude/skills` is a symlink to the harness fork of `mattpocock/skills`. The upstream
plugin is disabled in this project on purpose: running both makes every model-invoked skill
a coin flip between two versions.

### How every response ends

**`SYS-011`.** Unless the work is *finished* — finished, not merely blocked — close every
response with these four, in order:

1. **Quick context** — where things stand, in the fewest words that still orient.
2. **What is required** — the actual next operation. Not options.
3. **What is recommended** — what should happen, where that differs from what must.
4. **Why** — the reason the recommendation is what it is.

### Decisions put to the architect are numbered

**`SYS-014`.** Every decision put to the architect carries an **explicit number**, and the
numbering **resets at each decision fork** rather than running on through the session.

### Git operations are bookkeeping

**`BLD-017`.** Branching, staging, committing, pushing, opening a pull request, merging and
deleting a merged branch are **mechanical steps in closing work**, not decisions. Perform them
unasked and report what was done.

The split is **content versus carriage**: carriage is the agent's, content is the architect's.

*These three are stated here rather than pointed at, deliberately (`BLD-012`, `BLD-018`). They
govern every response at every tier including turns where no skill fires, so they must be in
context before an agent knows it needs anything — the one thing a skill cannot do.*

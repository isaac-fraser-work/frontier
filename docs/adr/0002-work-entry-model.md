# How a unit of work enters the harness

**Status:** accepted.

*Derives from `SYS-002`, `SYS-003`, `SYS-005`, `SYS-007`, `BLD-001`, `BLD-002`, `BLD-005`.*

`BLD-005` left the entry model open when `SYS-005` retired wayfinder's map. A unit of work is
**one derivation, carried out by one subagent, from a named context entry to a committed change
and a cited record.** The controller derives every unit; units live in `docs/context/working.md`
rather than on the issue tracker, because the citation chain the method rests on has to be one
graph in one tree, and `BLD-001` requires a hand-run increment to produce identical records with
no tooling.

## Decision

### What a unit is

One derivation. It carries a name, not a number: its durable identity is the commit that closes
it, and a second identity would be a second thing to keep in sync.

Well-formed on three tests, all checkable by reading the unit alone.

1. **Cited.** It names the `BLD-` entry it derives from, and through it the `SYS-` entry. Uncited
   is a defect on the same terms as `docs/context/build.md`'s own header rule: an uncited unit
   produces uncitable records, and `/audit` traverses citations or it traverses nothing.
2. **Stated.** What it changes is stateable precisely now. This is wayfinder's fog-of-war test,
   kept intact — the bar is whether you can state it now, not whether you can do it now. What
   fails this is not a small unit; it is not a unit.
3. **Declared.** It names what it **reads** (context entries, paths) and what it **writes**
   (paths). This is what makes a unit schedulable, and it makes *a layer is never authored from
   below* checkable by inspection: a subagent-tier unit declaring a write to
   `docs/context/build.md` is malformed on its face.

A unit closes when its writes are in the tree, its record is written, **and its criterion has
been met** — a fourth test, `Criterion`, added by `SYS-012` and specified in `BLD-011`: fixed
when the unit is derived, derived from actual system context, and naming the entry it derives
from. The first three tests were declarative and an agent could satisfy them by asserting it
had done the work; the criterion is what makes closure evidential.

A unit that escalates has not failed — it holds (`SYS-003`).

**Its writes need not be code.** A research finding, a prototype, an ADR are all changes to the
tree. Work outside the tree entirely — provisioning, access, anything that must happen before a
derivation can proceed — writes the facts it produced into its own working-context entry, and
that entry is its output. This is where wayfinder's four ticket types went.

### How one comes into existence, and who may create one

**The controller, and nobody else.** Decomposing build context into units is one interpretation
among several, which makes it a build-tier act (`architect-mode/context-layers.md`, question 2)
belonging to the tier that holds that layer.

Three things trigger a derivation, and there is no fourth:

- The controller composes a wave and derives units from the `BLD-` entries not yet discharged.
- A closed unit's handoff makes something previously in fog stateable, and it graduates.
- A new or amended `SYS-` entry forces re-derivation of what depended on it — including every
  entry `/audit` overturns.

**The architect creates none.** They author `CONTEXT.md`; units fall out of re-derivation. Under
wayfinder the map was a picking surface for a human choosing what to work on next. Here there is
no picking surface, because a backlog is a build artifact and the architect is never asked a
build question.

**A subagent creates none.** Work it discovers goes upward in its handoff and the controller
decides whether it becomes a unit. Handoff is the upward channel for **facts**; escalation is the
upward channel for **gaps**. A subagent writing its own next unit is authoring build context from
below.

**The roles create units, not the parties.** In manual mode (`BLD-001`) the architect wears the
controller's hat, and the unit they write is still derived from build context and still cited.
Holding the top layer's authority does not license an uncited unit.

### Where it lives

**`docs/context/working.md`, in the repo. Not the issue tracker.**

The slot already exists: working context holds *"what the last wave completed, what the next wave
is, and the handoffs between them."* Open units are the next wave.

Two reasons, both methodological (`SYS-002`):

- **The citation chain has to be one graph.** Forensic lines, `BLD-` entries, ADRs and the trail
  all cite `SYS-` ids, and `/audit` traverses from an id to everything citing it. Put half of
  those in a hosted tracker and the traversal has two stores, one of which is not in the clone,
  not in the commit and not greppable. That chain is the only guard on under-escalation
  (`architect-mode/escalation.md`), and a chain with a hole is not a shorter chain.
- **`BLD-001` disqualifies the tracker outright.** The hand-run increment must produce the same
  records with no tooling. Records in issue comments need `gh`, network, auth, and the proxy CA
  workaround `docs/agents/issue-tracker.md` already carries by hand. Records in the tree need a
  text editor. A siting whose manual mode is the degraded one fails the requirement that produced
  it.

~~The tracker stays the repo's tracker for work arriving from **outside** the derivation —
triage, reports. Nothing derived is filed there.~~

**Superseded by `SYS-009`, 2026-08-19.** This ADR preserved a slot for work arriving from
outside the derivation. The architect has since settled that **nothing does** — every unit is
derived, and there is no second door. The slot is empty and the tracker leaves the design
entirely; `docs/agents/issue-tracker.md` survives only as capability for the repo's own pull
requests. `/triage`, `/to-spec` and `/to-tickets` are retired with it. Struck rather than
edited, because this ADR reasoned correctly from what was settled at the time.

### How dependencies are expressed

**They are not. They are computed.**

A blocking edge records sequence; what the harness needs is interference. Under `BLD-002` the two
diverge hard: the first backlog is small and highly coupled, nearly every item touching the same
few documents, so a structural edge graph would be near-complete and carry no information.

So no edges are stored. The controller composes a wave by intersecting declarations: **a unit
whose reads meet another unit's writes goes in a later wave; two units writing the same path never
share one.** Ordering is derived at composition time from data the unit already carries for other
reasons, so there is no graph to maintain, rewire, or find stale.

A unit that genuinely cannot be stated until another closes fails test 2. It is not blocked; it is
fog, and it graduates when the earlier unit closes.

This is the specification for `/frontier` (T1), whose own assessment names collision detection as
its novel content and frontier-finding as free. Nothing above waits on it.

### Where the forensic record goes

**In that unit's entry in `docs/context/working.md`.** `architect-mode/records.md` sites the line
"wherever that unit of work records its outcome" and names two venues; this model selects the
second, because no ticket is in the loop. Settled here rather than inherited.

Subagents return forensic lines in their handoff and the controller transcribes them **verbatim**.
Editing a line from above rewrites the record of a decision the editor did not take.

**Durability is the commit, not the file.** Working context is volatile and superseded per wave,
while the citation chain has to outlive it. The record is committed in the same commit as the
change it describes, so supersession is a commit and never a loss — the record persists at the
site of the change, which is what *at the site of the decision* means once the file has moved on.
`/audit`'s traversal therefore reads history, not only the working tree.

Controller decisions do not lean on this. A decision its own layer authorised lands as a `BLD-`
entry or an ADR, durable by construction, and the forensic line points at it.

### The cap

Both halves of wave-scoping survive, on restated grounds.

- **One unit per subagent.** The original guard was a single agent exhausting its context, which
  is real and unchanged — but it is no longer the primary one. An agent closing two units writes
  one handoff covering two derivations, and the forensic lines lose their attribution. The cap is
  what holds unit and record one-to-one.
- **One wave per controller session.** Context exhaustion at the tier where it bites hardest: the
  controller holds build context plus every escalation in the wave.

Under `BLD-002` most waves will be one unit wide, because the backlog is coupled. **That is the
correct output, not a degraded one** — a wider wave on that backlog is two units deciding the same
thing twice.

### Manual mode

`BLD-001` runs the first increment by hand. It is not a reduced form of the model: every step is
the same step, with one human occupying both agent roles. It needs a text editor and `git`.

1. Read `CONTEXT.md`, then `docs/context/build.md`. *(Controller.)*
2. Choose the `BLD-` entry to derive from. Write the unit into working context's next wave — its
   citation, its reads, its writes, what closed looks like. Apply the three tests. If it fails
   **stated**, leave it in fog and pick another.
3. Compose the wave by intersecting declarations. Two units writing the same path go in different
   waves. Mark each unit HITL or AFK.
4. Work one unit. *(Subagent.)* **Consult only what the unit carries.** This is the step manual
   mode can cheat silently, because the human already knows everything a subagent would have to be
   told.
5. On hitting what the unit does not cover, escalate. Controller hat: answer from build context,
   or derive from actual. Where actual does not reach it, the architect writes a `SYS-` entry —
   that is the architect deciding, and it is never recorded as a forensic line.
6. **Record every question you answered without looking it up** as the escalation it would have
   been. `BLD-001` makes the by-hand increment the test of the tier model, and a test that cannot
   record a miss measures nothing.
7. Write the record into the unit's working-context entry: `## Committed without asking`, one
   cited line per decision.
8. Commit the change and the record together.
9. Close the wave. Supersede working context's state; the closed units' records stay in the
   commits that carried them.

### Not carried over from wayfinder

`SYS-005` permits reuse and does not require it. `SYS-002` decides each case on which part of the
method the mechanism expresses.

| Mechanism | Verdict | Result of the `SYS-002` test |
| --- | --- | --- |
| The map issue | **Cut** | A picking surface for a human choosing work. The architect does not pick units — they author the layer above them. Nothing left to express. |
| Decision tickets | **Cut** | A ticket routes a decision by queue; the tiers route it by which layer covers it. Keeping both means where the work was filed decides which tier answers. |
| Native blocking edges | **Cut as stored state** | Expresses sequence where the method needs interference. Survives only as a computation over declarations. |
| Claim by assignee | **Cut** | Arbitrates a race between independent sessions. The controller allocates every unit, so there is no race to arbitrate. |
| The four ticket types | **Cut** | `research`/`prototype`/`grilling`/`task` is a dispatch table naming which skill to run, and dispatch is not method. The contract already requires a prototype for product shape and `/grilling` for interrogation. |
| HITL / AFK | **Kept** | Expresses that product shape is always the architect's and is never committed silently. The only attribute that changes who may close a unit, and marked at derivation so it is non-silent before an agent is placed to commit it silently. |
| Fog of war | **Kept, promoted** | Now well-formedness test 2, and the replacement for blocking. Chart only what can be stated precisely now. |
| Refer by name | **Kept, narrowed** | Not for architect legibility — the architect does not read the backlog. A unit is named because its identity is its commit, and a number would be a second identity to reconcile. |
| Tracker operations | **Kept, out of the loop** | `docs/agents/issue-tracker.md` remains the repo's tracker capability for work arriving from outside the derivation. |

## Considered Options

**A. Rebuild wayfinder under a new name.** A backlog issue with child units, native dependency
edges, one closed per session. Named because it is what arrives by drift rather than by choice:
the scaffolding is retained by `SYS-005`, the tracker doc still documents every operation, and the
whole thing is one rename from working. Rejected on scope, exactly as `SYS-005` states it — the
map exists to be picked from by a human, and this harness's human authors the layer above the
backlog and is never asked a build question. It additionally splits the citation graph and makes
`BLD-001`'s hand-run increment the degraded path.

**B. Tracker as the home, records in the tree.** Units as issues, forensic lines in `working.md`.
Rejected: it pays the tracker's cost for none of its benefit — two stores to keep consistent, an
entry model that stops when `gh` does, and the one thing a tracker is genuinely good at,
visibility to a human who picks, is the thing this model does not want.

**C. A dedicated backlog file** — `docs/context/backlog.md`, separate from working context.
Rejected: working context is already specified as holding what the next wave is, so this adds an
artifact to fill a slot that is wired and empty. It also invites the quiet failure — a backlog
nobody supersedes drifts into a plan maintained alongside build context rather than derived from
it.

**D. Units as decisions rather than derivations.** Wayfinder's sizing rule: one unit per decision
that changes how the system behaves. Rejected because the harness already routes decisions, by
escalation. Making a decision into a unit puts it in a queue to reach the tier that could have
answered it on the spot, and the architect's interruption rate stops measuring context
completeness once it is a function of scheduling.

## Consequences

- **`/audit`'s traversal now spans git history.** Forensic lines from closed units live in commits
  once working context is superseded, so "find everything citing that id" is no longer a
  working-tree grep. Its *one ticket per overturned entry* resolves to one unit per overturned
  entry, derived by the controller like any other.
- **`BLD-005` needs amending.** It names `/frontier` as the intended answer; `/frontier` composes
  waves from units and presumes an entry model rather than supplying one. It also frames the
  retained scaffolding as reuse-or-replace, and the outcome is neither — it splits, mechanism by
  mechanism.
- **Waves on the first backlog will be one unit wide.** `BLD-002`'s backlog is coupled by
  construction, so the harness will look slow while self-hosting. `SYS-002` makes that
  inadmissible as an argument against the model.
- **Nothing here waits on a tool.** Every step is executable with an editor and `git`, which is
  what lets `BLD-001`'s increment test the model rather than a tool built on it.
- **Manual mode's honesty is unenforced.** Steps 4 and 6 depend on a human declining to use
  knowledge they hold. Nothing checks it, and `SYS-007` makes it likeliest to fail here, where the
  architect holds unusually deep context in the domain. The failure is silent: a by-hand increment
  that never escalates reads exactly like one whose context was complete.

## Committed without asking

- Units live in `docs/context/working.md`, not on the issue tracker — the citation chain has to be one graph in one tree [BLD-001]
- Only the controller creates a unit — decomposing build context into units is a build-tier act [`architect-mode/context-layers.md`, see BLD-007]
- The forensic line for a decision inside a unit lands in that unit's working-context entry — `records.md`'s second venue, selected because no ticket is in the loop [`architect-mode/records.md`, per BLD-007]
- Durability of a record is the commit, not the file — working context supersedes, and the commit keeps the record at the site of the change [BLD-001]
- Dependencies computed from declared reads and writes at wave composition, never stored as edges — an edge records sequence and a coupled backlog needs interference [BLD-002]
- The four wayfinder ticket types cut, HITL/AFK kept — the types are a dispatch table; the split is who may close the unit [SYS-002]
- One unit per subagent kept on restated grounds — it holds unit and record one-to-one, with context exhaustion second [SYS-002]

> **REFERENCE COPY — NOT THIS PROJECT'S LAYER.**
>
> This is the **harness's own** build system context, shipped so that the contract's citations
> resolve from inside a project. The doctrine in this directory cites `SYS-nnn` and `BLD-nnn`,
> and those ids mean *these* entries — never the project's.
>
> **Your project's entries carry your run's prefix** (`RUN.md`), and live in your own
> `CONTEXT.md` and `docs/context/build.md`. Nothing here is editable, and nothing here derives
> downward into your project: it is here to be cited against, not built on.

# Build system context

One interpretation of [`CONTEXT.md`](../../CONTEXT.md) into how this harness is built.
Derived downward and never authored from below: where this contradicts actual system
context, this is what was wrong. Schema in
[`architect-mode/context-layers.md`](../agents/architect-mode/context-layers.md).

Every entry cites the actual-context entries it derives from. **An entry citing nothing is a
defect**, not a shortcut.

---

## BLD-001 — The first increment is built by hand, outside the harness

*Derives from `SYS-007`, `SYS-001`.*

`SYS-007` points the harness at its own construction, which creates a bootstrap: the harness
cannot organise the work that builds the thing that organises work. The first increment is
therefore done manually, with the tiers followed by hand rather than enforced by tooling.

This is not a concession. The tier model's core premise is untested, and `SYS-003` makes the
architect present anyway — so the by-hand increment **is** the test, and it happens before
the chain is encoded into the one component everything routes through.

**Rejected:** build `/frontier-control` first and retrofit the learning. It would bake an
unvalidated escalation chain into the controller, and the controller is exactly where a bad
assumption is hardest to see afterwards, because every escalation passes through it.

## BLD-002 — The tool roadmap is the first backlog

*Derives from `SYS-007`.*

The work the harness organises first is the building of its own remaining tools. No external
backlog is needed or wanted, and the tool specs in `rework/tool-specs.md` are the starting
inventory — assessed before `SYS-001` … `SYS-007` existed and therefore re-ranked by
`BLD-003`, not adopted as written.

## BLD-003 — The tool set is ranked by which part of the method it expresses

*Derives from `SYS-002`, `SYS-003`, `SYS-004`.*

`SYS-002` makes *"this would produce better results"* inadmissible as an argument for a
component. Ranking the six proposals by what they express rather than what they yield:

The `T1`…`T8` labels are the tool-spec numbering from
[`rework/tool-specs.md`](../../rework/tool-specs.md), **not** part of the id scheme in
[`ids.md`](../agents/ids.md) — they name proposals in a brief, carry no permanence guarantee,
and nothing cites them as authority.

| Tool | Standing | What it expresses |
| --- | --- | --- |
| `/context` (T2) | **Core** | The architect authors the top layer; everything derives from it |
| `/frontier-control` (T3) | **Core** | The escalation chain — each tier queries its own layer |
| `/audit` (T8, built) | **Core** | Retrospective citation check; the only guard on under-escalation |
| `/frontier` (T1) | Partial | Collision detection is methodological; wave throughput is not. Build the first, not the second |
| `/env-check` (T7) | Support | Operational hygiene, expressing no part of the method |
| `/clanker` (T6) | Off-path | Delegated context authorship. `SYS-004` makes it explicitly invoked, so nothing waits on it |
| `/partition` (T5) | **Cut** | Pure context efficiency. Expresses no part of the method and fails `SYS-002` outright |

**Rejected:** the ordering in `rework/README.md`, which put `/env-check` second and
`/clanker` on the critical path. Both rested on unattended runs completing without a human —
`SYS-003` and `SYS-004` removed that premise, so the ordering it justified goes with it.

## BLD-004 — `CONTEXT.md`'s query interface is designed before its prose format

*Derives from `SYS-004`, `SYS-006`.*

The escalation chain is a **lookup** against actual system context: stage 2 and stage 3 both
resolve to *"does my layer cover this?"* If that lookup is fuzzy, the controller degrades
back into the judgement call the tiers replaced, and `SYS-006`'s bar on suggested answers
makes it worse rather than better — an agent that cannot tell whether the layer covers
something, and may not propose what it would say, has nothing left but to escalate
everything.

So *queryable* is specified first and the prose format follows from it.

**Specified in [`ADR-0001`](../adr/0001-context-query-interface.md)**, which outgrew a line.
Two candidate shapes for the architect to react to sit in
[`0001-candidates/`](../adr/0001-candidates/). The ADR corrects this entry on three points:
the split below is **not clean** (any structure the lookup needs is structure the architect
must type, so the requirement lands partly in their layer); the chain has **three** query
stages, not the two named here; and stage 3 queries the layer **above** the controller rather
than its own — an imprecision this entry inherited from the tier-crossing test's wording in
`architect-mode.md`, and which is flagged upward rather than patched here.

**Split by layer:** how the file is looked up is a build decision and is taken here. How it
**reads to the architect** is product shape, so it is theirs, and per the contract it is
resolved against a concrete artifact rather than in the abstract — two candidate shapes
built and reacted to, not a question asked cold.

## BLD-005 — How work enters the harness ~~is open~~ — **settled by ADR-0002**

*Derives from `SYS-005`. Superseded in substance by
[`ADR-0002`](../adr/0002-work-entry-model.md); kept because two of its claims were wrong and
the record of that matters more than a tidy entry.*

**Wrong claim 1:** it named `/frontier` (T1) as the intended answer. `/frontier` composes
waves from units that already exist — it presumes an entry model rather than supplying one,
so it was pointed at a slot it cannot fill.

**Wrong claim 2:** it framed the retained wayfinder scaffolding as reuse-as-is *or* replace.
The outcome was neither: the scaffolding split mechanism by mechanism — four cut, two kept,
one kept as a computation rather than as stored state.

It also overstated the openness. `context-layers.md` already specified working context as
holding *"what the next wave is"*, so the slot was wired and empty; what was genuinely open
was only whether the tracker got reused. Original text follows.

---

*Original, `SYS-005`.*

`wayfinder`'s map-and-ticket model retired with it, and nothing has replaced it. There is
currently no defined way a unit of work arrives, and the tracker is empty.

`/frontier` (T1) is the intended answer and is not built. Recorded here so it is found rather
than rediscovered — it is invisible to `scripts/check-architect-mode.sh`, which is green.

**Not yet decided:** whether the retained tracker scaffolding from
`skills/deprecated/wayfinder/` is reused as-is, or replaced. Reuse is permitted by `SYS-005`
but not required by it.

## BLD-006 — Packaging shape ~~is open~~ — **mechanism settled by `BLD-015`**

*Derives from `SYS-008`, `SYS-007`. Both open questions closed by `BLD-015`; struck in
place rather than rewritten, because what was open — and that it was closed by the tree
rather than by a decision — is the record worth more than a tidy entry.*

`SYS-008` requires the harness be installed and invoked locally as a tool rather than
operated from inside its own checkout. ~~**The mechanism is undecided**: a skills directory
symlinked per project, a Claude Code plugin, or something thinner.~~ **`BLD-015` takes the first
of those three**, and records why the second was rejected.

`SYS-008` also removes the usual reason packaging is hard — with one user there is no
distribution, no versioning for others, no configuration surface, and no compatibility
surface to hold stable. What remains is only: where the files live, and how a session in
another directory reaches them.

**Constrained by `SYS-002`:** packaging expresses no part of the method, so it earns no
elaboration beyond making the harness reachable. The thinnest thing that works is correct
by definition here, and anything more is a component justified by convenience.

~~**Not yet decided:** whether the package is pointed only at this repository — which is all
`SYS-007` currently requires — or at arbitrary local work. Deciding this early would spend
design effort on a case that does not exist yet.~~

**Decided by `BLD-015`:** arbitrary local work. The deferral was correct when it was written and
was overtaken by the tree rather than by a decision — which is the finding, not a defect in this
entry.

## BLD-007 — Process decisions cite the contract; content decisions cite context

*Derives from `SYS-002`. Corrects a hole in
[`architect-mode/records.md`](../agents/architect-mode/records.md).*

`records.md` requires every forensic line to name **the context entry** that authorised it,
and states that if you cannot name one you had no authority and must escalate. Writing
`ADR-0002` found the hole: some decisions are authorised by the **contract** rather than by
any context entry. *"Only the controller may create a unit of work"* is authorised by the
tier definitions in `context-layers.md`, and no `SYS-` or `BLD-` entry reaches it. Under the
rule as written, that decision would have to escalate — which is plainly wrong, since the
contract is what constitutes the tiers in the first place.

So the citation names whichever actually authorised it:

| Decision is about | Cites |
| --- | --- |
| **Content** — what gets built, and why this rather than that | The `SYS-`/`BLD-` entry |
| **Process** — who may do a thing, at which tier, in what order | The contract file and section |

The rule that matters is unchanged and is not weakened by this: **uncited is still
unauthorised.** Naming the contract is a citation anyone can go and check, which is the whole
test. What is now forbidden is citing an entry that does not reach the decision, which is
worse than citing nothing — it reads as derived and passes inspection.

**Not applied retroactively.** Existing forensic lines stand; this governs new ones.

**Escalation note:** `records.md` is contract, and this entry corrects it from build tier
rather than amending it. That is deliberate — the correction is a derivation, not the
architect's decision, so it is recorded where derivations live and flagged upward rather than
written into doctrine unilaterally.

## BLD-008 — `CONTEXT.md` takes shape B, declared exclusions

*Derives from `SYS-004`, `SYS-006`. Specified by
[`ADR-0001`](../adr/0001-context-query-interface.md); shape chosen by the architect, since how
the file reads to them is product shape.*

Each entry is a rule, then what it **rules out**, then what it **leaves open**, then the
reasoning demoted beneath. The rule and the exclusions settle a question; the reasoning is
read but never on its own grounds to rule anything out.

**The reason the shape was chosen, recorded because it will be re-litigated.** The lookup has
two steps and each candidate hardened one. Shape A made *silent* the trustworthy verdict and
*covered* the arguable one — failing toward a derivation that cites an entry not really
reaching it, which is a **silent misderivation**. Shape B makes *covered* trustworthy and
*silent* arguable — failing toward the architect being asked something the file already
settled, which is **an interruption**. `escalation.md` already settled that asymmetry: prefer
the interruption. B puts the visible failure on the side that fails.

**Cost, accepted:** `SYS-008` licenses the architect's own register and B is the shape that
charges for it.

**Agents do not fill `Leaves open`.** Four entries read *Not declared*, and that blank is the
architect's to fill or leave. A blank is not an invitation — filling it is authoring the top
layer, which `SYS-004` forbids and `SYS-006` forbids proposing.

## BLD-009 — Six skills cut; the tracker leaves the design

*Derives from `SYS-002`, `SYS-008`, `SYS-009`.*

`to-tickets`, `to-spec`, `triage`, `setup-matt-pocock-skills`,
`improve-codebase-architecture` and `ask-matt` moved to `skills/deprecated/`. Twelve remain.
Reason per skill in [`skills/deprecated/README.md`](../../skills/deprecated/README.md);
evidence in [`docs/skills/reconciliation.md`](../skills/reconciliation.md).

`SYS-009` removes the tracker as a work surface, which takes three of the six with it.
`SYS-002` takes the rest: a skill that improves output while expressing no part of the method
has no defence once *"it produces better results"* is inadmissible.

**`docs/agents/issue-tracker.md` and `triage-labels.md` are superseded, not deleted.** The
repo still has pull requests, and the `gh` invocations and proxy-CA workaround are real
capability. Both now carry a banner saying they are how to talk to GitHub, never where work
goes.

**The regression path mattered more than the cut.** `setup-matt-pocock-skills` regenerated
`issue-tracker.md`, `domain.md` and `triage-labels.md` from seed templates in its own folder
that were never migrated — no context layers, no tiers, wayfinder's map protocol with no
deprecation banner. Four skills told an agent to run it when configuration looked missing.
Retiring it removes a live path back to the superseded model, which is worth more than the
skill cost.

## BLD-010 — `/context` interviews and transcribes; it never decides

*Derives from `SYS-010`, `SYS-004`, `SYS-006`.*

`SYS-010` settles what `/context` is. It grills the architect, and for every decision they
take it writes a shape-B entry into `CONTEXT.md` **with their words quoted verbatim above
it**. It decides no content, proposes no filling for a gap (`SYS-006`), and writes nothing it
cannot quote.

**The operative constraint is that the quote comes first.** An entry is written from a record,
not fitted with one afterwards — a quote selected to justify an entry already drafted is the
citation failure `/audit` exists to catch, moved up a layer where nothing above it can catch
it.

**Where the architect's answer is an acceptance** — *"yes"*, *"agreed"*, *"do that"* — the
record attests that a choice was made, not what its wording should be. The wording is then the
agent's, and the entry says so. `SYS-006` is the worked example, and it is marked in place.

**Consequence for the escalation chain.** Stage 5 previously ended with *"the architect extends
actual context"*, which was silent on who typed. It now has a defined mechanism: the architect
decides, an agent transcribes against the record, and the controller re-derives. The gap that
prompted it is quoted in the entry that closed it, so the chain is inspectable end to end —
from a symptom, to the decision, to the context that authorised it, to the words that produced
that context.

## BLD-011 — The criterion is a cited derivation, and is executable where it can be

*Derives from `SYS-012`, `SYS-002`.*

A unit gains a **Criterion** alongside its citation, its statement and its declarations. It is
written when the unit is derived, it names the `SYS-` entry it derives from, and it is what the
unit closes against. `ADR-0002`'s closing test — writes in the tree, record written — is
necessary and no longer sufficient.

**Executable by default.** `SYS-012` promotes test infrastructure rather than implying it, so
the criterion is expressed as something that runs wherever it can be. In this repo that means a
check in `scripts/check-architect-mode.sh`: the criterion and its enforcement are the same
artifact, and a checkpoint cannot pass by assertion.

**Where it cannot be executed, that is a finding and it is recorded.** A criterion judged by
prose is judged by whoever benefits from passing it. Such a unit is marked HITL — not because
product shape is involved, but because the only available judge is the architect.

**The citation is what makes the criterion honest.** Without it the controller writes both the
test and the thing tested, which is one interpretation of success competing with the
interpretation already written down. With it, an agent proposing a convenient criterion has to
name what in actual system context makes it the right one — and that name is checkable by
check 10 like any other.

**Consequence for reporting.** `SYS-012` makes checkpoints unexposed but reported. The
criterion's result therefore belongs in the unit's working-context entry and in the response
that closes the unit, never in a request for approval before the work runs.

## BLD-012 — What carries an instruction is decided by when it must be known

*Derives from `SYS-011`, `SYS-002`. Evidence in
[`docs/research/claude-md-rules-skills.md`](../research/claude-md-rules-skills.md) and
[`behaviour-surfaces.md`](../research/behaviour-surfaces.md).*

A skill body is fetched **only after** the model has decided the skill is relevant, and that
decision reads the skill's `description` alone. So **an instruction the model must follow in
order to know a skill applies cannot live in that skill's body.** This is a mechanical
property, not a style preference, and it decides placement on its own:

| The instruction | Carried by |
| --- | --- |
| Must be in force before any skill fires, or on a turn where none does | **`CLAUDE.md`** — always loaded |
| Applies only when working in a given area of the tree | **A rule** — matched on path |
| Is a procedure, or long reference, reached once a task is identified | **A skill** — fetched on invocation |
| Governs whether a skill should be reached at all | That skill's **`description`** |

**`SYS-011` is the worked example and the reason this entry exists.** It governs every
response of every agent at every tier, including turns where no skill fires — which is the
manual mode `BLD-001` puts the harness in right now. It is therefore in `CLAUDE.md`, stated
rather than pointed at, and it was carried by nothing at all until this entry.

**The contract has the same problem and this does not fix it.** `docs/agents/architect-mode.md`
sits three hops from always-loaded and the last two hops are optional by design, so nothing
puts it in context on a turn where no skill fires. Recorded here rather than solved: the fix is
not obvious, because inlining the contract into `CLAUDE.md` would pay its full cost on every
turn and duplicate the doctrine that `check 5` exists to keep single-sourced.

**None of the three mechanisms enforces anything.** All three shape behaviour by being read.
Enforcement in this repo is `scripts/check-architect-mode.sh` and nothing else — which is why
`SYS-012` requires a criterion to be executable wherever it can be. An instruction carried only
by a document is a hope; an instruction carried by a check is a constraint.

## BLD-013 — A declaration's presence is checkable; its completeness is not

*Derives from `BLD-011`, `SYS-012`. Closes a finding wave 1 raised against
[`ADR-0002`](../adr/0002-work-entry-model.md).*

Check 12 fails the build on any unit missing one of `ADR-0002`'s four tests — **Cited**,
**Stated**, **Declared**, **Criterion**. A malformed unit is caught at derivation time, which is
when it costs nothing.

**What it cannot reach, stated plainly so nobody mistakes green for safe.** The check verifies
the four tests are *present*. It cannot verify their *contents* are true, and one of those is
load-bearing:

| | Checkable | Why |
| --- | --- | --- |
| **Declared** is present | Yes | Check 12 |
| **Declared writes** are accurate | In principle | The closing commit's changed paths can be compared against them. Not built — no linkage exists yet between a unit and the commit that closed it |
| **Declared reads** are complete | **No** | Nothing can observe what an agent read. There is no artifact of a read |

The third is the one wave 1 failed: the `/context` unit did not declare `docs/skills/authoring/`,
read it anyway, and closed green. **This matters beyond bookkeeping** — `ADR-0002` composes waves
by intersecting declarations, so an undeclared read is an undetected collision, and two units the
controller believed independent can silently decide the same thing twice.

**The only available guard is procedural, and procedure is a hope rather than a constraint**
(`BLD-012`): an agent that needs something outside its declaration **stops, amends the
declaration, and records the amendment as a finding**. Nothing enforces it. Recorded as a known
hole rather than papered over, because a check that is green on an incomplete declaration is
exactly the confidently-wrong signal this repo has now produced twice.

## BLD-014 — Layer 0 is a generated index; interfaces load through subagents

*Derives from `SYS-013`, `SYS-008`.*

**`docs/context/tools.md` is generated from the live skills' frontmatter**, never hand-authored.
`SYS-013` bars layer 0 from holding anything but tool selection, and a generated file enforces
that structurally: anything smuggled in does not survive regeneration. A hand-maintained index
would rely on `ring` declining to write down what it learns, which is a hope
(`BLD-012` — no document enforces anything).

Each entry is **name, one-line purpose, invocation mode**. That is the whole schema. The
one-line purpose is the skill's own `description`, not a summary written by `ring` — a summary
is where interpretation enters, and interpretation at layer 0 is contamination with extra steps.

**A tool's operating detail is loaded by a subagent, on demand, and never retained.** `ring`
knows what exists; it does not know how anything works. This is the same mechanical property
`BLD-012` records from the other direction: a skill body loads only once something has decided
the skill is relevant. `ring` is that decider, so it needs the **descriptions** — which are
loaded anyway — and must not accumulate the **bodies**.

**Consequence for the spawn chain**, which is now three deep and was previously two:

| Depth | Who | Holds |
| --- | --- | --- |
| 0 | `ring` | Layer 0 — which tool, what for |
| 1 | A tool, e.g. `/frontier-control` | Its own layer (build context) |
| 2 | A unit worker | Working context |

`ring` never occupies depth 1. If it operates a tool itself it has collapsed the abstraction it
exists to provide, and the collapse is invisible from outside because the output looks the same.

## BLD-015 — Packaging is one symlinked harness, a ~~copied contract~~ **symlinked contract (`ADR-0003`)**, and a scaffold script

*Derives from `SYS-008`, `SYS-007`. Settles the mechanism `BLD-006` left open and the scope
question it deferred. **Retro-derived** — see the closing note.*

`bin/claude-init-frontier` scaffolds any local directory onto the harness. The shape it commits
to, in five parts:

| Part | Mechanism | Why this one |
| --- | --- | --- |
| **Skills** | ~~`.claude/skills` is a **symlink** to `$FRONTIER_REPO/skills`~~ **Repointed at `$FRONTIER_REPO/archive/skills` by `BLD-021`.** | ~~One harness, one copy. An edit propagates to every project and no project can drift into a fork of the fork.~~ True, and it propagates **half-finished** work with exactly the same reliability — the harness is developed in the tree every project reads. `BLD-021` splits the workshop from what ships |
| **Contract** | ~~`docs/agents/` and `architect-mode/` **copied** from the harness, per project~~ **Symlinked. Corrected by [`ADR-0003`](../adr/0003-run-as-project.md).** | Skills reference them by repo-relative path, so they must exist in the project tree — a symlink satisfies that. The copy cited `SYS-001`…`SYS-013`, which are defined only here, so every scaffolded project began with **twelve dangling citations**. The argument this row's neighbour makes against copying *skills* applies unchanged to the contract |
| **`CONTEXT.md`** | **Not scaffolded at all** | `SYS-004`. The layer is the architect's, and a template is an agent's first draft of it |
| **Upstream skills** | Plugin enabled at **user** scope, disabled **per project** | Nine forked skills are model-invoked and so are their upstream twins. With both live, which one fires is a coin flip |
| **Tracker** | Issues on, **no labels created** | `SYS-009`. Nothing arrives from outside the derivation, so there is nothing to label. The tracker is capability for pull requests, never a work surface |

**Scope: arbitrary local work, not only this repository.** `BLD-006` deferred that as a case that
did not exist yet; the script decides it by scaffolding any directory. `SYS-007`'s
recorded-not-pursued note governs the consequence and needs no amendment — a project the harness
is pointed at takes **its own** `CONTEXT.md` and this one stays the harness's. The script
implements exactly that, by copying the contract and refusing to write `CONTEXT.md`.

**Rejected.**

- **Copy the skills per project.** Every project becomes a fork of the fork and a harness edit
  reaches none of them. With one user there is no distribution problem for a copy to solve.
- **Embed the contract in the script as heredocs.** The predecessor did this; the embedded copies
  reached twenty lines of divergence while still carrying doctrine the live contract had retired.
  An embedded copy is a second author of the contract.
- **Ship the harness as a Claude Code plugin.** `BLD-006` named it as a candidate. The plugin path
  is what carries the *upstream* skills and is precisely what has to be switched off per project;
  making the harness a plugin too would rebuild the model-invocation collision it exists to avoid.

**Where `SYS-002` bites, stated rather than argued away.** Packaging expresses no part of the
method, so it earns no elaboration beyond making the harness reachable — and 537 lines exceeds the
thinnest thing that works. What defends the excess is not convenience: `copy_if_absent`, the
settings merge-after-backup and the idempotent re-run all exist so the scaffold cannot overwrite a
project's own decisions, which is the derivation rule applied to somebody else's tree. The
remainder — GitHub creation, the launch step — has no such defence and is convenience.

**Retro-derived, and marked.** The mechanism was committed in `c951a4b` before this entry existed.
No unit derived it, nothing cited it, and `build.md` read *"the mechanism is undecided"* for as long
as the mechanism sat in `bin/`. This entry is written from the tree backwards — structurally the
move `/context` forbids one layer up, where the entry is drafted first and the record fitted to it
afterwards. It is marked rather than concealed, because an unmarked retro-derivation is
indistinguishable from a derivation, and telling those apart is the entire job of the citation
chain. The finding is in [`working.md`](working.md).

## BLD-016 — No agent writes a `SKILL.md`; ~~the unlock is per session~~ ~~tools are built from a non-activated session~~ **only the architect can apply one**

*Derives from `SYS-007`, `SYS-003`. Records a constraint **discovered**, and the interpretation
taken of it.*

**The constraint.** Activating the fork — `ln -sfn ../skills .claude/skills`, which `CLAUDE.md`
instructs — brings this repo's tool directory under the agent-config paths the sandbox denies. An
agent's write to `skills/` fails with `EROFS`. Found 2026-08-24 by a write probe, not by design.

**The consequence, stated plainly.** `SYS-007` says the harness builds itself. While activated,
that is **false for its own tools.** Every `SKILL.md` here was written by the architect by hand,
and no agent in an activated session could have written one. Three waves recorded this as
`BLD-001`'s manual mode, which reads as a bootstrap choice — it was also the only option
available, and nothing in the record distinguished the two. **A constraint and a decision look
identical when the outcome is the same**, which is the general form of the thing to watch for.

~~**The interpretation taken.** The unlock is granted **per session**, by the architect, for a wave
whose units declare writes to `skills/`, and closed after. It is never standing.~~

**Wrong. Corrected 2026-08-24, same day, by probe.** There is no unlock to grant. A `/sandbox`
grant and a session restart both left `skills/` read-only, and a wider probe shows the denied set
is **every path that defines agent behaviour** — `~/.claude/`, `~/.claude/skills/`, and this
repo's `skills/`, which is caught because `.claude/skills` resolves into it. The project's
`docs/`, `scripts/` and `.claude/` are all writable. That is a built-in carve-out, not a setting,
so no configuration reaches it.

**What replaces it, confirmed by probe 2026-08-24.** The deny is created by **activation**, not by
the path. A session opened from `~/uv-test/` — which has no `.claude/` directory, so no
`.claude/skills` symlink resolves into the repo — reports `frontier/skills/` as
**WRITABLE**. The same absolute path is denied from an activated session and writable from a
non-activated one.

So the mechanism is: **tools are built from a session where the harness is not activated.**
`SYS-007` holds, and it holds across two sessions rather than one.

**The consequence for the wave model, which is the load-bearing part.** A subagent inherits its
session's sandbox, so a unit that writes a `SKILL.md` **cannot be dispatched by `/ring` at all** —
not because of who may do it, but because the process that would do it cannot write the file. That
is a new class: a unit the controller may derive and may not dispatch. `ADR-0002` has no mode for
it, HITL/AFK does not describe it, and inventing one here would be deciding at derivation time
something that belongs to wave composition. **Named, not resolved.**

*This entry was written from a single probe and asserted a mechanism nobody had tried. It is the
same failure wave 2 recorded about checks — written once, and nothing checks the checker — and it
survived less than a day. Struck rather than rewritten, because the speed of the correction is
the useful part of the record.*

**Rejected.**

- **Blanket unlock in the project sandbox config.** It lets every future session edit the skills
  governing its own behaviour mid-run — the same failure as an agent widening its own permissions,
  which the sandbox already refuses on the architect's behalf. Worse than the `CONTEXT.md`
  exposure, because a skill edit changes what the agent does next rather than what it later cites.
- **Leave it locked permanently.** Coherent, and it makes `BLD-001`'s manual mode permanent for
  anything touching `skills/` rather than a bootstrap phase. Rejected because it forecloses
  `SYS-007` for most of the remaining backlog.

~~**The shape is clanker's**, applied to a filesystem permission: authority lent for a run the
architect chose to lend it for, never inferred from conditions.~~ Struck with the mechanism it
described. **What survives is the constraint**, which the probe strengthened rather than weakened:
no agent in an activated session can write a `SKILL.md`, and a unit that declares one will fail at
dispatch.

*Wording is the agent's, chosen from three options put to the architect. Marked in place on the
same principle `SYS-006` is marked — an accepted framing is not an authored one.*

**Second correction, 2026-08-25, by probe. The conclusion held; the mechanism was one gate short,
and the remedy was wrong.**

The entry said the deny is created by activation, and that tools are therefore built from a
session where the harness is not activated. Probed again with a permissive posture in place
(`defaultMode: auto`, sandbox bypass available):

| Probe | Result |
| --- | --- |
| Write `skills/.probe` inside the sandbox | `EROFS` — as this entry describes |
| Same write **outside** the sandbox | **Succeeds.** The sandbox layer does yield |
| Change a `SKILL.md`'s invocation mode, outside the sandbox | **Refused by the permission classifier** |
| Edit a `SKILL.md`'s prose, outside the sandbox | **Refused by the permission classifier** |

So there are **two** gates, not one. The sandbox filesystem deny is the weaker and is what this
entry found; behind it sits a permission gate that refuses any write to a file defining agent
behaviour — `SKILL.md`, `agents/*.yaml`, `.claude/settings.json`, anything under `~/.claude/` —
**regardless of tool, sandbox state, or content**. A new non-skill file under `skills/` passes; a
skill definition does not.

**What this changes.** Deactivating the harness does not help: the second gate is on the action,
not the path, so it is not something a differently-opened session clears. `BLD-019`'s parked class
is real and its exit is not a non-activated session — it is **the architect applying the change
themselves**. Nine units closed that way on 2026-08-25: derived, staged, verified against the
conformance check in a scratch tree, then applied by the architect in one command.

**Why the rule is right rather than merely present.** It is `SYS-004` one layer down. An agent may
not edit what governs how agents behave, for the same reason it may not write `CONTEXT.md` — and
the platform enforces in code what this repo spent five waves deriving in doctrine. The rejected
option below anticipated exactly this and was correct for a reason it could not yet name.

*An agent claimed mid-session that this entry was "wrong in the record" on the strength of the
second probe row alone, before running the third and fourth. It was not wrong; it was incomplete,
and the claim was made from a `touch` that changes an mtime and no content. Recorded because the
error is the one this repo keeps finding: **a probe that confirms what you expected, stopped one
step early.***

## BLD-017 — Git operations are bookkeeping; agents perform them unasked

*Derives from `SYS-011`, `SYS-003`, `SYS-009`. `ADR-0002` had already sited the commit inside a
unit's closing; this makes the consequence explicit.*

**The rule.** Branching, staging, committing, pushing, opening a pull request, and merging to
`main` are **mechanical steps in closing work**, not decisions. An agent performs them without
asking and reports what it did. The architect is not a git client.

**This is not a widening of agent authority.** `ADR-0002` step 8 is *"commit the change and the
record together"*, and *"durability is the commit, not the file"* — a unit whose record is
uncommitted has not closed. Asking permission to commit is asking permission to finish. The same
holds for the merge: an open PR is a unit whose durable record sits on a branch nothing reads,
and `/audit`'s traversal reads history.

**The split is content versus carriage.**

| | |
| --- | --- |
| **Agent's, unasked** | branch, add, commit, push, open a PR, merge to `main`, delete a merged branch |
| **Architect's, always** | what goes *in* it — every `SYS-` entry, every `Leaves open` line, the `skills/` unlock (`BLD-016`), anything `SYS-004` or `SYS-006` reserves |

`SYS-004` reserves what a layer **says**. It says nothing about which process types the command
that stores it.

**Why it was being asked anyway — the part worth keeping.** Nothing here ever required it. The
interruptions came from a generic assistant convention carried by the agent's own operating
instructions rather than by any entry in this repo, applied on top of a harness that had already
decided otherwise. **An unexamined default from outside the derivation is what `SYS-009` bars,
arriving as behaviour rather than as work** — and it cost more architect attention in one session
than every genuine escalation to date, of which there have been none.

**Rejected: ask on merges to `main` only.** It is the same defect at lower frequency, and it puts
the interruption at the moment of least information — the content was already reviewable in the
commit, and the merge adds nothing for the architect to judge.

**Carrier.** Per `BLD-012` this must reach `CLAUDE.md` to be in force before any skill fires: an
agent deciding whether to ask about a commit has not loaded `build.md`. That carrier is a unit and
belongs to wave 4. Until it lands, this entry governs only sessions that have read build context.

## BLD-018 — `SYS-014` is carried by `CLAUDE.md`, `SYS-015` by `/ring`'s body, `SYS-016` by nothing

*Derives from `SYS-014`, `SYS-015`, `SYS-016`, through `BLD-012`. Triggered by `ADR-0002` — a new
or amended actual-context entry forces re-derivation of what depended on it.*

Three entries landed on 2026-08-19 (`ac43e03`, reaching `main` in `5edfcd5`). Until this entry
**nothing in the build or working layer cited any of them**. The layer above moved and the
derivation did not follow — the drift [`context-layers.md`](../agents/architect-mode/context-layers.md)
calls deriving upward, arrived at by omission rather than by edit, and the same shape as the
uncited scaffold recorded between waves 3 and 4, one layer up.

Each needs a carrier or explicitly needs none. `BLD-012` decides carriage by **when the
instruction must be known**, and that decides all three without further judgement.

| Entry | Must be known | Carrier |
| --- | --- | --- |
| `SYS-014` — decisions are numbered, numbering resets per fork | On any turn where a decision is put to the architect, including one where no skill fires | **`CLAUDE.md`**, stated rather than pointed at, on `SYS-011`'s grounds |
| `SYS-015` — layer 0 is regenerated at the start of a run | Once a run has begun; a run begins by invoking `/ring` (`SYS-013`), whose body is loaded at that moment | **`skills/ring/SKILL.md`** |
| `SYS-016` — the interrogation method as practised is confirmed | Never as a new obligation — it withholds a change rather than requiring an act | **None**, deliberately |

**`SYS-015` is currently carried by nothing, and the behaviour it approves is emergent.**
`skills/ring/SKILL.md` says layer 0 is generated from the skills and never edited by hand; it
nowhere says to regenerate it at the start of a run. The architect approved a behaviour that is
written down nowhere, and an approved behaviour with no carrier is one that need not recur: the
first run that skips it presents as the wrong tool being chosen, with nothing to point at. The
unit that fixes it writes `skills/`, so it is derived and **undispatchable** under `BLD-019`.

**`SYS-016` is recorded here precisely because it needs no carrier.** An entry nothing derives
from is indistinguishable from an entry nobody derived. This one bars a change rather than
requiring an act — it holds the gap-statement form of `SYS-006` and `escalation.md` against
replacement absent a decision by the architect — so the derivation is the finding that there is
nothing to carry.

**Rejected.**

- **Point at `CONTEXT.md` from `CLAUDE.md` for `SYS-014`.** A pointer is a fetch, and the rule
  binds the turn on which the decision is put — including a turn on which nothing is fetched.
- **Carry `SYS-015` in `CLAUDE.md` as well, since `skills/` cannot be written today.** It binds
  the start of a run rather than every turn, and `CLAUDE.md` pays its cost on every turn
  (`BLD-012`). Siting an instruction by what is currently writable is letting a sandbox author
  the build layer.
- **Treat all three as satisfied because the observed behaviour already matched.** `SYS-014`
  exists because an agent named a defect in its own routing and shipped it anyway; behaviour
  that matched once is not a carrier.

## BLD-019 — A unit whose writes fall under `skills/` is derived, marked undispatchable, and parked

*Derives from `SYS-007`, `SYS-003`, through `BLD-016` and [`ADR-0002`](../adr/0002-work-entry-model.md).
Settles the class `BLD-016` named and left explicitly to wave composition.*

`BLD-016` established that no agent in an activated session can write `skills/`, and that a
subagent inherits its session's sandbox — so a unit writing a `SKILL.md` is one **the controller
may derive and may not dispatch**. It named the class and refused to resolve it at derivation
time. This resolves it at composition time, which is where it belongs.

**The rule.** Such a unit is derived in full — **Cited**, **Stated**, **Declared**,
**Criterion**, exactly like any other — and then marked in place:

```markdown
**Dispatch: blocked.** Writes fall under `skills/`, which is read-only in an activated
session (`BLD-016`). Not counted in this wave; no subagent is spawned for it.
```

It is **not counted in the wave**, no subagent is spawned, and it **stays in working context
across waves** until a session with the fork deactivated closes it.

**Why not fog.** Fog (`ADR-0002` test 2) is for what cannot be *stated* yet. These are stateable
precisely now; what is missing is a process able to write the file. Filing a constraint as fog
destroys the derivation and makes a blocked unit look like an unformed idea.

**Why not HITL.** HITL/AFK says **who may close** a unit. This says **which process can write
it**. They are different axes and both can apply to the same unit.

**Why parked rather than dropped.** Dropping loses the derivation, and the next composition
re-derives it from scratch without knowing it is a re-derivation — which is how the same
question gets two different answers with nothing recording that it was asked twice.

**The consequence, stated rather than smoothed.** A wave composed from an activated session is
composed from a **strict subset** of the derived units, and the subset is defined by a sandbox
rather than by the method. Working context therefore shows both sets every wave: what was
dispatched, and what was derived and could not be. A wave that shows only what it ran reports
the sandbox as if it were the plan.

**Rejected.**

- **Unlock `skills/` for the wave.** There is no unlock; `BLD-016`'s correction struck it by
  probe. A rule written against a mechanism that does not exist is worse than none.
- **Dispatch anyway and let the write fail.** It spends a subagent to produce a handoff about a
  permission, and it makes a sandbox constraint look like a defect in the unit.
- **Hold the whole wave until a non-activated session is available.** It converts a partial
  constraint into a total stop, and `SYS-003` holds a run for a question only the architect can
  answer — not for a filesystem the architect has already been told about.

## BLD-020 — A run is a project; runs are parallel peers — **settled by `ADR-0003`**

*Derives from `SYS-007`, `SYS-013`, `SYS-015`, `SYS-004`, `SYS-010`, through `BLD-015` and
[`ADR-0002`](../adr/0002-work-entry-model.md). Full decision in
[`ADR-0003`](../adr/0003-run-as-project.md) — it outgrew a line here.*

`SYS-007` left one line on what happens when the harness is pointed at something other than
itself, and marked it **"Nothing live."** `BLD-015` cited that line as though it were a settled
specification and scaffolded arbitrary directories on it. **A placeholder and a specification look
identical when both are one line** — the same class as `BLD-016`'s *"a constraint and a decision
look identical when the outcome is the same."*

**What `ADR-0003` settles.**

| | |
| --- | --- |
| **A run is a project** | One `/ring` invocation, one complete derivation chain, one directory. `CONTEXT.md` is per run, transcribed by ring under `SYS-010` |
| **Runs are peers** | No parent, no import, no inheritance. A new run starts from nothing, on `SYS-015`'s grounds |
| **`courier` is the only crossing** | Read-only, spawned per query, returns cited briefings, reports conflicts and never resolves them |
| **Ids carry a per-run prefix** | Allocated at init, globally unique across `runs/`, which is what makes a cross-run citation checkable |
| **The contract is symlinked** | Corrects `BLD-015`. The copy left twelve dangling `SYS-` citations in every scaffolded project |

**What it does not settle, named rather than resolved.** `courier` writes a `SKILL.md`, so it is
underivable-to-dispatch under `BLD-016` and parked under `BLD-019`. Until it exists, runs are
sealed with no crossing at all — which is the current behaviour, and is why run 2 of the first
scaffolded project could not see what run 1 had established.

**Rejected.** Inheritance by declared parent or import list; one `CONTEXT.md` per repository with
runs holding only layers 0 and 3; `courier` restricted to closed runs; a registry file. Each is
recorded with its reason in `ADR-0003`'s *Considered Options*.

## BLD-021 — Projects are pinned to a frozen archive, not to the live harness

*Derives from `SYS-007`, `SYS-008`, `SYS-015`, through `BLD-015` and
[`ADR-0003`](../adr/0003-run-as-project.md). Corrects `BLD-015`'s propagation model and finishes
the argument it made and did not apply.*

**The architect, verbatim:**

> i want it to reach to an archived version so i can update concurrently without worrying about
> using half done harness

**Interpretation** (`SYS-019`), the agent's, marked as such. Given while an archive directory was
already being built as a *template* source; the message redirected it from templates-only to a
**frozen copy of the whole harness**. The context: the harness had been edited continuously for a
whole session, and every scaffolded project reads the same tree.

**The rule.** `archive/` is a frozen snapshot of the harness — `skills/`, `docs/agents/`,
`scripts/`, plus the project templates. `bin/claude-init-frontier` wires every new project into
**`archive/`** and never into the live root. Refreshing it is `scripts/promote-to-archive.sh`, run
deliberately.

**What `BLD-015` got right and what it missed.** It reasoned: *"One harness, one copy. An edit
propagates to every project and no project can drift into a fork of the fork."* Both halves are
true. What it did not say is that **propagation has no notion of finished** — a half-written skill
reaches every project the instant it is saved, and the harness is developed in the tree every
project reads. The live root is a workshop; `BLD-015` shipped from it.

| | Live-root symlink (`BLD-015`) | Archive pin (`BLD-021`) |
| --- | --- | --- |
| A finished harness edit reaches projects | Immediately | On promotion |
| A **half-finished** one | Immediately | Never |
| Which harness a project was built against | Unanswerable | `archive/ARCHIVE.md`, pinned to a commit |
| Drift into a fork of the fork | Impossible | Impossible — projects still link, never copy |

**Proved, not asserted.** A marker appended to the live `docs/agents/domain.md` was invisible to a
scaffolded project; after `promote-to-archive.sh` it appeared; after reverting and re-promoting it
was gone.

**Three things it also finishes.**

- **The heredocs become files.** `BLD-015` rejected embedding the *contract* as heredocs — *"an
  embedded copy is a second author"* — and left `CLAUDE.md`, `RUN.md`, `.gitignore` and
  `.claude/settings.json` as heredocs in the script. They are now real files in `archive/` with
  `{{PLACEHOLDER}}` substitution. ~~Adding a scaffolded file is adding a file, not editing a
  script.~~

  **That clause was false when written, and is true from 2026-08-26.** The archive was laid out as
  a mirror and *consumed as a lookup table*: the script read a hardcoded list of eleven paths from
  it. Adding a file to `archive/` did nothing, and three directories this entry says exist "so the
  shape exists before anything fills it" appeared in no project. The property was recorded as the
  reason for the change and was never built.

  **What closed it.** `bin/claude-init-frontier` now **walks** the archive: directories created,
  payload files (`scripts/`, `docs/agents/`) linked, everything else rendered. `skills/` and
  `ARCHIVE.md` are the only exclusions and both are stated in the code. `scripts/promote-to-archive.sh`
  proves it on every promotion by scaffolding a throwaway project and failing if any archive path
  does not reach it — probed by sabotage, exit 1.

  *Conformance could not have caught this. A scaffold passed all sixteen checks while missing most
  of what the archive declared, because no check compared the two. The defect was found by a person
  reading a report about the layout, a day later.*
- **The harness's own layers ship as read-only reference.** `docs/agents/harness-context.md` and
  `harness-build.md`, banner-marked as *not this project's layer*. The contract cites `SYS-nnn` and
  `BLD-nnn`; before this those citations resolved to nothing from inside a project. `ADR-0003`'s
  symlink fixed authorship and drift and **relocated** this defect rather than closing it, which
  the first scaffold under the archive exposed as 17 dangling ids.
- **The checks became project-aware.** Wave 5 shipped `scripts/` into projects, which turned
  *"the script is absent"* into **43 violations on a fresh scaffold** — worse, by this script's own
  header, because a permanently-red check is one people stop reading. Checks 1–9 are the harness's
  and are skipped in a project; an **empty chain is now a state, not a violation**, and engages the
  moment `CONTEXT.md` exists. A fresh scaffold is green.

**Rejected.**

- **A git worktree or tag pin instead of a copy.** No duplication, and the pin would be a ref
  rather than a directory. Rejected because the archive has to be readable and diffable without
  git plumbing, and `SYS-008`'s single user makes 600K of duplication a non-problem.
- **Gitignoring `archive/`.** Leaner, and it makes *"which harness was this project built
  against"* unanswerable after the fact — which is most of the point.
- **Automatic promotion** on commit or on green. That is the propagation this entry exists to
  stop, re-entering through a hook.
- **Templates only, live payload.** The first reading of the instruction. It would have fixed the
  heredocs and left every project still reading a tree under active edit.

**Leaves open.** Whether existing projects scaffolded against the live root are repointed. None
were re-scaffolded here.

---

## Why the other two layers are absent

`docs/context/trail.md` does not exist yet, correctly.
The trail is clanker's, and clanker has never run. It is created lazily, when there is a
first entry for it, per [`domain.md`](../agents/domain.md).

[`working.md`](working.md) was opened when wave 1's first unit was derived. It carries no ids
by design — citing volatile state from a durable record breaks the moment the code moves — so
a closed unit's durable record is the commit that carried it, not the entry.

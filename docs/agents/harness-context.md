> **REFERENCE COPY — NOT THIS PROJECT'S LAYER.**
>
> This is the **harness's own** actual system context, shipped so that the contract's citations
> resolve from inside a project. The doctrine in this directory cites `SYS-nnn` and `BLD-nnn`,
> and those ids mean *these* entries — never the project's.
>
> **Your project's entries carry your run's prefix** (`RUN.md`), and live in your own
> `CONTEXT.md` and `docs/context/build.md`. Nothing here is editable, and nothing here derives
> downward into your project: it is here to be cited against, not built on.

# Actual system context

What `frontier` is for, how it must behave, and what it must not become.

**This layer is the architect's**, ids are permanent, and a superseded entry is struck in
place with a pointer to its successor —
[`architect-mode/context-layers.md`](docs/agents/architect-mode/context-layers.md) holds
the rest.

Each entry is a rule, then what it **rules out** and what it **leaves open**, then the
reasoning. The rule and the exclusions are what settle a question; the reasoning is there to
be read and is never on its own grounds to rule anything out.

---

## SYS-001 — This is a harness, not a pipeline

*Architect, 2026-08-19.*

**Record** (`SYS-010`), verbatim:

> build harness, i do not want to focus on an end destination of what it should output based on input

*One of three answers given in a single message; parts 1 and 2 of it are the record for SYS-003/SYS-004 and SYS-005.*

The system is a **build harness**: a machine the architect points at work, which derives
what to do from what the architect has said the system is for.

**Rules out.**

- Specifying the harness by what it outputs for a given input.
- A target artifact it exists to produce.
- Measuring its success by the quality of one output.

**Leaves open.** Not declared.

**Why.** A harness specified that way would be tuned toward producing that artifact, and
the methodology would become whatever happened to produce it.

## SYS-002 — Composed on rationale, not expectation

*Architect, 2026-08-19.*

**Record** (`SYS-010`), verbatim:

> i want to build the harness wrt. what methodology I want to implement, regardless of the outcome. harness should be composed on the rationale not expectation.

*Same message as SYS-001.*

The harness is built with respect to **the methodology to be implemented, regardless of the
outcome**: every component earns its place by which part of the rationale it embodies, never
by what it is expected to yield.

**Rules out.**

- *"This would produce better results"* as an argument for adding something.
- *"This produced a poor result"* as an argument, on its own, for removing something.
- A component that improves outcomes while embodying no part of the method.
- Dropping a component that expresses the method because a run disappointed.

**Leaves open.** Not declared.

**Why.** The question is always whether the piece expresses the method. This is the
governing form of what the build ethos calls *a program, not THE program* — the target is
never the right system, only a coherent one.

## SYS-003 — Attended by default

*Architect, 2026-08-19.*

**Record** (`SYS-010`), verbatim:

> it is attended, unless "clanker" called for

The architect is **present**: the normal mode of operation is a run with a human to answer
it, and the harness is designed for that case rather than around its absence.

**Rules out.**

- Designing around the architect's absence.
- Continuing past a question only the architect can answer, with no architect there. The
  run holds.
- Unattended operation as a mode the harness degrades into on its own.

**Leaves open.** Not declared.

**Why.** Stopping is a correct outcome and it is how the gap becomes visible.

## SYS-004 — The architect alone defines this layer

*Architect, 2026-08-19.*

**Record** (`SYS-010`), verbatim:

> user is only one allowed to define the top layer, unless clanker is called explicitly.

*Same message as SYS-003.*

The architect is the **only** party permitted to define actual system context: no agent may
write this layer, and no agent may cause it to be written, by any route.

**Rules out.**

- An agent writing an entry here.
- An agent causing one to be written, by any indirect route.
- Inferring clanker's licence — from a run being long, from the architect being absent,
  from work being blocked.
- An agent concluding that conditions warrant clanker. That is the decision only the
  architect may take.

**Leaves open.** Whether this context covers a given question. Any tier may report that it
does not; none may decide what covering it would say.

**Why.** `clanker` is the single exception and it is a **delegation, not a fallback**: the
architect lends the authority for a specific run by invoking it explicitly. The prohibition
is on filling this layer, not on questioning it.

## SYS-005 — Wayfinder is superseded

*Architect, 2026-08-19.*

**Record** (`SYS-010`), verbatim:

> wayfinder is to be deprecated, this new method works on fundamentally different scope. can still use underlying mechanisms and tools/scaffolding etc. so maybe leave there under folder of deprecated (can still reference but doesnt fill context as not being used)

The `wayfinder` skill is **deprecated**: the harness works at a fundamentally different
scope, and wayfinder's shape — a map of tickets a human picks from, one resolved per
session — is not a smaller version of it.

**Rules out.**

- Wayfinder as the organising method.
- Pointing back at the deprecated skill as authority for anything.
- Loading it. It lives at `skills/deprecated/wayfinder/` so it stays referenceable without
  being loaded.

**Leaves open.** Which of the retained mechanisms get reused, and where — the ticket types,
the HITL/AFK split and the fog-of-war discipline of charting only what can be stated
precisely now are retained and **may** be reused; nothing requires it.

*Narrowed by `SYS-009`:* the **tracker operations** are no longer among them. This entry left
their reuse open; `SYS-009` closed it. Pointer added rather than the entry rewritten — the
later, more specific entry governs.

**Why.** What is retired is wayfinder as the organising method, not the tools it proved out.
A reused mechanism is recorded as build context on the harness's own terms.

## SYS-006 — An escalated gap carries no recommendation

*Architect, 2026-08-19.*

**Record** (`SYS-010`), verbatim:

> i accept reccomendation, continue

***Acceptance, not statement.** The wording of this entry is the agent's, accepted rather than authored. The weakest record in this layer — see SYS-010.*

A gap put to the architect states what could not be decided, what this context says nearest
to it, and the behavioural contrast between the ways it could be filled — and carries **no
suggested filling**.

**Rules out.**

- Any agent proposing what an entry in this layer should say.
- A suggested filling attached to a gap, at any level of confidence.
- Treating confidence as the test. The bound is which layer the answer lands in:

| Answer lands in | Recommend? |
| --- | --- |
| Actual system context — a new or amended `SYS-` entry | **No.** State the hole and the contrast; stop. |
| Product shape, resolved against something concrete | Yes, and resolve it against an artifact rather than in the abstract. |
| Something the architect gives rather than decides — budget, access, hardware, a deadline | Yes. |
| Build or working context | Yes — and it is the agent's decision to take, not the architect's. |

**Leaves open.** Not declared.

**Why.** An entry in this layer governs every derivation made afterwards. Once it is written
down, *"the architect did not object"* is indistinguishable from *"the architect decided"*,
and the record cannot tell the two apart later. Recommending elsewhere costs nothing,
because the answer does not become governing context.

This settles a conflict in the contract as written: `architect-mode.md` requires a
recommendation with every decision put to the architect, and `escalation.md` defines a gap
statement as three things and nothing else. The gap statement wins in this layer.

## SYS-007 — The harness builds itself

*Architect, 2026-08-19.*

**Record** (`SYS-010`), verbatim:

> it builds itself

The work this harness is pointed at is **its own construction**: there is no separate
project, and the first thing it organises is the building of the rest of it.

**Rules out.**

- A separate project the harness is really for.
- Treating `SYS-001` … `SYS-006` as provisional because they are entries about the harness.
  `CONTEXT.md` is the harness's own actual system context and that is correct.
- Reading a low interruption rate while self-hosting as evidence that `CONTEXT.md` is
  complete.
- A second project sharing this file.

**Leaves open.** Nothing live. Recorded and not pursued: if the harness is later pointed at
something other than itself, that project takes its own `CONTEXT.md` and this one stays the
harness's — noted so the two are not collapsed later.

**Why.** **Accepted property:** the architect holds unusually deep context in this domain,
so the premise that an agent knows the technical area better does not hold as strongly here
as it would elsewhere. This was presented as a consequence and chosen with it attached.

It cuts a useful way, and the distinction matters when reading results: self-hosting is a
**weak test of the trust premise** and a **strong test of the derivations**. On a domain the
architect does not know, a bad derivation is invisible to them — it cites an entry, reads as
sound, and cannot be challenged. Here they can check it. So a derivation that survives
review here has actually been reviewed.

## SYS-008 — One user, local first, packaged for use

*Architect, 2026-08-19.*

**Record** (`SYS-010`), verbatim:

> it is for me only. i want it locally primarily for use, so should be packages as such

The harness is for **the architect alone** — nothing in it accommodates a second user — and
it is wanted **primarily for use**, installed and invoked locally as a tool and packaged as
such, rather than operated by working inside its own repository.

**Rules out.**

- A second user, and anything built to accommodate one.
- A configuration surface, and neutral defaults. A preference is an assumption, not a
  setting; anything that would have been configurable is decided once instead.
- Effort spent making `CONTEXT.md` read cold to a stranger. It may be terse and written in
  the architect's own register.
- *"Does the harness work?"* measured against anyone but the architect. The premise that an
  agent holds more technical context is measured against one person's context and no other.
- Working inside this repository as the primary way it is operated.

**Leaves open.** Whether packaging collides with `SYS-007`. A **live edge, not yet a fork**:
`SYS-007` points the harness at its own construction while packaging implies invoking it
from somewhere that is not this repository, and those are different axes — what it is
pointed at now, and how it is installed. If the package is ever pointed at work outside this
repo, `SYS-007`'s note applies: that work takes its own `CONTEXT.md`, and this one stays the
harness's.

**Why.** Terseness, the absence of a configuration surface, and measuring *"does it work"*
against one person are **consequences accepted** — presented with the decision and taken
with it attached, not incidental to it.

---

## SYS-009 — Nothing arrives from outside the derivation

*Architect, 2026-08-19.*

**Record** (`SYS-010`), verbatim:

> nothing arrives from outside

*One of three answers given in a single message: "shape B, cut them all, nothing arrives from outside".*

Every unit of work in this harness is **derived** — it comes from a `BLD-` entry, which comes
from a `SYS-` entry, which the architect wrote. There is no second door.

**Rules out.**

- A tracker, queue, inbox or backlog holding work that derives from nothing.
- Triage, as an activity — there is no undirected input to sort.
- A unit of work created by anything other than the controller deriving it.
- Treating a bug, an idea or an observation as a unit in its own right. It is evidence that a
  context entry is wrong or missing, and it enters by changing that entry.

**Leaves open.** Not declared.

**Why.** With one user (`SYS-008`) and the harness pointed at itself (`SYS-007`), there is
nobody to file work from outside and nowhere for it to come from. Keeping a second entry path
would mean the harness had two kinds of work with different provenance, only one of which
carries a citation — and the citation chain is the only guard on under-escalation. Work that
enters uncited cannot be audited, because there is nothing to audit it against.

This closes the slot [`ADR-0002`](docs/adr/0002-work-entry-model.md) reserved for work
arriving from outside the derivation. The tracker leaves the design.

## SYS-010 — An agent may transcribe, but only against a record

*Architect, 2026-08-19.*

**Record** (`SYS-010`), verbatim:

> transcription allowed, but only against a record

An agent may write an entry in this layer **only where the architect's own words are quoted
verbatim alongside it**, so that the claim to be transcribing rather than authoring is
something anyone can check.

**Rules out.**

- An entry here with no verbatim record of the decision it claims to transcribe.
- A record that paraphrases, tidies, corrects or completes what the architect said. It is
  quoted as typed or it is not a record.
- An agent deciding what an entry says and attributing it to the architect afterwards.
- Treating a record as authorisation for anything beyond what it says. Where the entry
  reaches further than the quote, the excess is authored, not transcribed.

**Leaves open.** Not declared.

**Why.** `SYS-004` forbids an agent writing this layer and permits any tier to question it,
which left a third act unaddressed — typing up a decision the architect had already taken.
Nine entries were written that way before this was settled.

The distinction between transcribing and authoring is invisible from outside, because both
produce an entry attributed to the architect and an agent's account of which it was doing is
exactly what cannot be trusted. **The record is what makes it checkable** — the same move the
citation rule makes for derivations, applied to the one layer that has no layer above it to
be checked against. `SYS-006` bars proposing what an entry should say; this bars claiming the
architect said it without showing that they did.

**The weakest record in this layer is `SYS-006`'s**, which is an acceptance of an agent's
proposal rather than the architect's own formulation. It is marked as such where it sits. A
record of the form *"yes"* attests that a choice was made, not what its wording should be —
the wording is the agent's and the entry is honest only while it says so.

## SYS-011 — Every response ends by naming the next operation

*Architect, 2026-08-19.*

**Record** (`SYS-010`), verbatim:

> prompt should only end without the output of {QUICK context}{what is required}{what is reccomended}{why its reccomended} if it is finished with its work. i do not want to have to prompt it to know what the next operations are.

A response closes with four parts, in order, unless the work is **finished**:

| Part | What it carries |
| --- | --- |
| **Quick context** | Where things stand, in the fewest words that still orient |
| **What is required** | What must happen next. Not options — the actual next operation |
| **What is recommended** | What should happen, where that differs from what must |
| **Why** | The reason the recommendation is what it is |

**Rules out.**

- Ending on a question and nothing else.
- Ending with work complete but the next operation unnamed.
- Making the architect ask *"what now?"* to find out what the system already knows.
- Burying the next operation inside prose rather than naming it under its own heading.
- Treating *"finished"* loosely. It means the work is done, not that this turn is.

**Leaves open.** Not declared.

**Why.** The architect holds whole-system context and does not track the build's state.
Requiring them to ask what happens next makes them do retrieval the system is already holding
— and it is the same defect as an escalation that reports a problem without stating the
behavioural contrast: correct, and useless at their altitude.

The bar is *finished*, not *blocked*. A response that is waiting on an answer still names what
happens once it arrives.

## SYS-012 — A unit closes against a criterion derived from this layer

*Architect, 2026-08-19.*

**Record** (`SYS-010`), verbatim:

> b) checkpoint details should be judged at creation, issue criterion using the layer 1 context (relation to user principal), doesnt need to be user exposed, just user-reported (promoted in-built test infrastructure also)

*The choice between two options was the agent's to offer; the requirement that the criterion
derive from this layer is the architect's own and is the load-bearing part.*

Work is staged. Each stage closes at a **checkpoint**, and the criterion for that checkpoint
is fixed **when the unit is derived**, never when it is closed. The criterion is derived from
**actual system context** — from what the system is for and its relation to the person it
serves — and names the entry it derives from.

It is **not exposed** to the architect for approval, and it is **reported** to them once
judged.

**Rules out.**

- A criterion written at closing time, by the agent whose work it judges.
- A criterion that cites nothing in this layer. It would be the tier that satisfies the test
  also setting it, which is no test.
- Closing a unit on assertion that the work was done, rather than on the checkpoint being met.
- Putting a checkpoint to the architect for approval before the work proceeds.
- Judging a checkpoint and not reporting the result.

**Leaves open.** Not declared.

**Why.** A criterion set at closing time is set by whoever needs to pass it, and a criterion
invented by the controller is one interpretation of success competing with the interpretation
of success already written down. Deriving it from this layer makes the test **the same kind of
object as every other decision here** — a derivation with a citation, checkable by anyone,
against something the architect actually said.

This is what makes closure evidential rather than declarative, and it is the only mechanism in
the design that catches a unit which completed **wrongly** rather than incompletely.

The checkpoint being unexposed but reported is the same split the whole harness runs on: the
architect is not asked a build question, and is told what was decided.

**Test infrastructure is promoted by this**, not implied by it. A criterion that no machine
can evaluate is a criterion judged by whoever benefits from passing it, which is the failure
this entry exists to prevent.

## SYS-013 — `ring` is the entry point, and holds layer 0

*Architect, 2026-08-19.*

**Record** (`SYS-010`), verbatim:

> i need "ring" skill, which 1) loads the interface to each driver (spawn subagents to give this, will include all the information to operate the tool correctly and effectively) 2) acts as primary interface with the user, acts as top level driver abstraction layer. will be used at start of project entry point, will spawn the apprpiate agents with correct loaded skill. will generally keep track of system, and be primary gateway to the tools (via subagents), which will then spawn sub-subagents; as has been already outlined. 3) it should hold an additional layer0 context level, such as not to contaminate. context needs to primarily focus on tool selection and delegation purpose, should not be directly used to obtain/route information.

`ring` is the **project entry point** and the top-level driver abstraction. It is the primary
interface with the architect and the gateway to every tool: it spawns a subagent per tool, and
those subagents spawn their own.

It holds **layer 0**, a context level of its own, kept separate so it does not contaminate the
others. Layer 0 is about **which tool and why**, and nothing else.

**Rules out.**

- Layer 0 holding information about the system being built. That is layer 1's.
- Reaching layer 0 to *obtain* or *route* information. It selects and delegates; it is not a
  lookup for anything else.
- ~~`ring` operating a tool itself. It spawns the agent that operates it.~~ **Narrowed by
  `SYS-017`, 2026-08-25.** It still spawns for every tool it can; the exception is the
  interview class, which a spawned agent cannot run because it has no channel to the architect.
- `ring` holding a tool's full operating instructions. It spawns a subagent to load an
  interface when one is needed.
- ~~Any tool being reached other than through `ring` at entry.~~ **Narrowed by `SYS-018`,
  2026-08-25.** `ring` remains the entry point for a run; the exclusion no longer means a tool
  may not be model-invocable, because that reading made three of the drivers unreachable by
  `ring` itself.

**Leaves open.** Not declared.

**Why.** A top-level agent that accumulates knowledge about the system stops delegating and
starts answering, and it is the one agent positioned to do that invisibly, because everything
below it arrives through it. Confining layer 0 to selection-and-delegation is what keeps the
abstraction an abstraction.

Loading each tool's interface through a subagent is the same discipline made structural:
`ring` knows what exists and what each is for, never how each works, so its context cannot
grow into the thing it is meant to route around.

## SYS-014 — Every decision put to the architect is numbered, and the numbering resets

*Architect, 2026-08-19.*

**Record** (`SYS-010`), verbatim:

> a question must always explicitly list every decision with a number, this should be Q1 (dont increment past each decision fork, reset)

A decision put to the architect carries an **explicit number**. Numbering **resets at each
decision fork** rather than running cumulatively through a conversation.

**Rules out.**

- Putting a decision to the architect without a number on it.
- Prose that solicits a view — *"if you have a view, say it"* — in place of a numbered decision.
- Numbering that keeps climbing across a session instead of resetting per fork.
- Siting a decision anywhere but as a numbered question: under a recommendation, inside a
  report, or as an aside.

**Leaves open.** Not declared.

**Why.** Stated after a question was routed sideways — offered as an optional aside under
*What is recommended*, while *What is required* read *"Nothing."* The agent **named the routing
itself** in the same message and shipped it anyway, so self-identification did not produce
self-correction. A number is what makes a decision impossible to slip in as prose, because
the number has to be written down and then answered.

The reset matters separately: cumulative numbering makes `Q7` a position in a transcript, which
means nothing once the transcript is gone. Reset per fork, a number is a position in **this**
decision, which is what the architect is actually answering.

Observed at [`docs/observations/0001-first-scaffold-and-ring.md`](docs/observations/0001-first-scaffold-and-ring.md),
entries 44-48 — the rejected framing and the corrected one sit adjacent there.

## SYS-015 — Layer 0 is regenerated at the start of a run

*Architect, 2026-08-19.*

**Record** (`SYS-010`), verbatim:

> it spawns an agent at the start to generate the tool list. I like this behaviour, doesnt take too much time or tokens and ensures important info is cheaply fresh each time.

Layer 0 is generated at the **start of a run**, not carried forward. The cost is accepted as
part of starting.

**Rules out.**

- Beginning a run against a tool list that was generated for a previous one.
- Treating layer 0 as durable between runs.
- Skipping the regeneration on cost grounds.

**Leaves open.** Not declared.

**Why.** Layer 0 is what a tool is selected from, so a stale one silently removes tools that
exist and offers tools that do not — a failure that presents as the wrong tool being chosen
rather than as anything being missing.

**Approval, not instruction.** The record is the architect approving an observed behaviour. The
imperative above is the transcriber's rendering of it, in the same class as `SYS-006` and marked
as such where it sits. Observed at
[`docs/observations/0001-first-scaffold-and-ring.md`](docs/observations/0001-first-scaffold-and-ring.md),
entries 2-3.

## SYS-016 — The interrogation method as practised is confirmed

*Architect, 2026-08-19.*

**Record** (`SYS-010`), verbatim:

> perfect interrogation method, exactly what i want

**Rules out.**

- Replacing the gap-statement form with anything else absent a decision by the architect.
- Reading later dissatisfaction with a *particular* question as dissatisfaction with the method.

**Leaves open.** Not declared.

**Why.** Said of a specific artifact rather than of a description, so this entry **points at
that artifact rather than re-specifying it** — four independent gaps, each with what the layer
says nearest and a contrast of consequence, and no suggested filling on any of them. It is
recorded at [`docs/observations/0001-first-scaffold-and-ring.md`](docs/observations/0001-first-scaffold-and-ring.md),
entries 22 and 48.

Re-describing the method here would put the transcriber's wording where the architect's approval
was, and the approval was of the thing, not of a summary of it.

**Approval, not instruction**, in the same class as `SYS-015`. What it confirms is that the
method already written into `SYS-006` and `escalation.md` is what he wants — moving it from
designed-and-untested to confirmed in use. It adds no new obligation.

## SYS-017 — `ring` may operate an interview-class tool in place, and still writes no entry here

*Architect, 2026-08-25.*

**Record** (`SYS-010`), verbatim — two messages, at two decision forks:

> 1b) 2a) ; once all the working out of the system has been done, then carry out the writeable-side repairs

> 1a) with the caveat that all enries to the user-defined system context must all carry a verbatim reference to carry along original interpretation, alongside the interpretation the ai will make given the chat context (aka have "this is what was said" alongside "this is what the most suitable interpretation of this is given the context in which it was asked")

**Interpretation** (`SYS-019`), the agent's, marked as such. Both are **acceptances of numbered
options whose wording was the agent's**, so the record attests that a choice was made and not how
it should be phrased. `1b` was put as *"Rule stands; `ADR-0003` is wrong and `CONTEXT.md` gets
written another way."* `1a` was put as *"Ring may operate interview-class tools in place,"* costing
the absoluteness of the depth 0/1 separation.

The context they were asked in: an audit had shown that `SYS-013`'s exclusions, `SYS-010`'s
verbatim requirement and `SYS-004`'s absolutism were **jointly unsatisfiable** — an interview needs
a live channel to the architect, the only live channel is the main session, the main session is
`ring`, and `ring` was forbidden from operating a tool. No tool requiring an interview could ever
run. The architect was asked which of the three rules bends and chose this one.

`ring` writes actual system context by **no route at all**. It **operates the tool that writes it**
— loading that tool's instructions into its own turn rather than spawning an agent for it — and
that tool transcribes. This applies to the interview class only: tools that must reach the
architect directly.

**Rules out.**

- `ring` writing an entry in this layer. `SYS-004` is untouched and remains unconditional.
- Treating this as a general licence to operate tools in place. It reaches the interview class
  and nothing else; every other tool is still spawned.
- Dispatching an interview-class tool to a subagent. A subagent has no channel to the architect,
  so the quote it records would be `ring`'s paraphrase and `SYS-010` would be satisfied in form
  and defeated in substance.

**Leaves open.** Which tools are interview-class beyond `/context`. Not declared.

**Why.** The failure this avoids is specific and was already observed: a dispatched agent writes a
record that is not a record and has no way to tell, because the only words it ever saw were the
ones passed down to it. Check 11 would pass — a quote block exists — and nothing downstream could
catch it, because everything downstream would derive from it and agree.

The cost is real and is not hidden: the depth 0/1 separation stops being absolute, and `ring` is
the one agent positioned to drift invisibly. What holds it is that operating a tool in place is
still operating **that tool's** instructions, not `ring`'s judgement.

## SYS-018 — The drivers are reachable by the model, not only by typing

*Architect, 2026-08-25.*

**Record** (`SYS-010`), verbatim:

> 1b) 2a) ; once all the working out of the system has been done, then carry out the writeable-side repairs

**Interpretation** (`SYS-019`), the agent's, marked as such. **An acceptance, not a statement** —
`2a` was put as *"Make the four drivers model-invocable,"* and the wording is the agent's.

The context: an audit found that `/ring` could not dispatch three of the four drivers. The
harness's own authoring rule says a user-invoked skill may never reach another user-invoked skill,
and `audit`, `context` and `frontier-control` were all user-invoked — while `SYS-013` forbade
reaching them any other way. They were unreachable in both directions, and the observed workaround
was `ring` spawning an agent to *summarise* a skill and dispatching from the paraphrase, so the
skill never ran as written.

The repo-native drivers are **model-invocable**, so `ring` can dispatch them. `ring` itself stays
user-invoked: it is the way in.

**Rules out.**

- `ring` being unable to reach a tool it is required to route work to.
- Reading `SYS-013`'s entry-point rule as a bar on model invocation. It bars a tool being *reached
  around* `ring` at entry, not a tool being reachable at all.
- `ring` becoming model-invocable. A run begins when the architect starts one.

**Leaves open.** Whether `implement` and `grill-with-docs` follow. The architect deferred both,
choosing to fix `implement`'s input model first and decide its invocation mode after — *"Fix
`/implement` first, decide after."*

**Why.** The cost was named before the choice and is accepted: a model-invocable driver can fire on
its own, mid-run, on a phrase that resembles its description. The two skills held back are exactly
the two with live upstream twins, where flipping them would also reopen a collision `BLD-015`
closed.

## SYS-019 — Every entry here carries the words and the interpretation taken of them

*Architect, 2026-08-25.*

**Record** (`SYS-010`), verbatim:

> 1a) with the caveat that all enries to the user-defined system context must all carry a verbatim reference to carry along original interpretation, alongside the interpretation the ai will make given the chat context (aka have "this is what was said" alongside "this is what the most suitable interpretation of this is given the context in which it was asked")

**Interpretation** (this entry), the agent's, marked as such. **This half is the architect's own
wording, not an acceptance** — it was attached to a numbered answer as a condition on it, and was
not among the options offered.

The context: it was given while settling which of three conflicting rules would bend, immediately
after an audit showed that a dispatched agent's "verbatim" quote could in fact be `ring`'s
paraphrase with nothing able to detect it.

Every entry in actual system context carries **two** things, separately and both visible: the
architect's words as said, and the interpretation taken of them **in the context in which they were
said**. The second is the agent's and is marked as the agent's.

**Rules out.**

- An entry carrying a quote and no interpretation. The reading then hides inside the rule's
  phrasing, where nothing can inspect it.
- An entry carrying an interpretation not marked as the agent's.
- Recording the interpretation without the circumstances that produced it. *What was asked, and
  why then* is part of what makes a reading checkable later.
- Treating this as licence to extend an entry past its quote. The interpretation is a reading of
  the record, never an addition to it.

**Leaves open.** Whether the existing sixteen entries are retrofitted. Not declared — this entry
does not reach back, and `SYS-016`'s and `SYS-006`'s in-place acceptance markings are the nearest
existing practice.

**Why.** `SYS-010` already required the quote, and `SYS-006` already required an accepted framing
to be marked as accepted rather than authored. Both address the same hazard from opposite sides,
and neither made the *reading* visible — an entry could quote faithfully and still rest on an
interpretation nobody could see, in the one layer with nothing above it to check against.

Making the reading explicit is what lets it be disputed. A rule stated without its interpretation
can only be obeyed or broken; stated with it, it can be found to have been read wrongly.


## Language

**Architect**:
The human driving the system. Holds whole-system context — what it is for, how it behaves,
what it must not become — and is not required to hold implementation context.
_Avoid_: user, owner, stakeholder

**Controller**:
The single long-lived agent that holds build system context, derives it from actual system
context, and spawns subagents. The only tier that absorbs escalations.
_Avoid_: orchestrator, coordinator, lead agent

**Subagent**:
An agent spawned for one unit of work, holding working system context and deciding code
semantics. Arrives with no history.
_Avoid_: worker, child agent

**Actual system context**:
What the system is for and how it must behave — the layer that would survive the system
being thrown away and rebuilt by a different team. Lives in `CONTEXT.md`.
_Avoid_: requirements, spec, product context

**Build system context**:
One interpretation of actual system context into structure and mechanism, with the
interpretations ruled out recorded alongside. Lives in `docs/context/build.md`.
_Avoid_: architecture doc, design doc

**Working system context**:
What the code does right now and what the last unit of work finished. Volatile; superseded
rather than amended. Lives in `docs/context/working.md`.
_Avoid_: status, progress notes

**Escalation**:
A report that a tier's own context layer does not cover a question, reframed into the
vocabulary of the tier receiving it. Never a request for permission.
_Avoid_: question, request, blocker

**Gap**:
The thing an escalation carries — what could not be decided, what the layer says nearest to
it, and the behavioural contrast between the ways it could be filled.
_Avoid_: unknown, open question

**Clanker**:
The one agent licensed to write actual system context in the architect's place, for a run
they explicitly invoked it for, against a mandatory audit trail.
_Avoid_: autonomous agent, delegate

**Trail**:
Clanker's append-only record in `docs/context/trail.md` — one entry per decision, recording
what it knew rather than what it concluded, backlinked to the `SYS-` entry it created.
_Avoid_: log, history

**Harness**:
This system: the assembly of contract, context layers and tools that derives work from
what the architect has said. Composed on rationale, not on expected output.
_Avoid_: framework, pipeline, workflow

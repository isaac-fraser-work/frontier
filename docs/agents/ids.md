# Identifiers and citations

How this repo names things, and how one document claims authority from another. The layer
model itself is in [`architect-mode/context-layers.md`](architect-mode/context-layers.md) —
this file is the id scheme underneath it, and why it is load-bearing rather than decorative.

## The families

| Id | Identifies | Who may create one | Lives in |
| --- | --- | --- | --- |
| `SYS-nnn` | One entry of actual system context — a rule about what the harness is for, how it behaves, what it must not become | **The architect decides it.** An agent may *type* one, only with the architect's words quoted verbatim beside it (`SYS-010`). Clanker may *decide* one, only for a run the architect explicitly invoked it for | `CONTEXT.md`, repo root |
| `BLD-nnn` | One entry of build system context — one interpretation of the layer above into structure and mechanism | The controller | `docs/context/build.md` |
| `ADR-nnnn` | A build decision that outgrew a line in `build.md`. Same rules as a `BLD-` entry, more room | The controller | `docs/adr/nnnn-slug.md` |
| `TRAIL-nnn` | One decision clanker took in the architect's absence, backlinked to the `SYS-` entry it created | Clanker, and nothing else | `docs/context/trail.md` — does not exist; clanker has never run |
| *(none)* | Working system context — what the code does now, what the last wave finished, what the next wave is | The controller, with handoff entries from subagents | `docs/context/working.md` |

All four families are permanent. Ids are never reused and never renumbered.

## In a scaffolded run, the prefix is the run's

The table above is written from inside the harness, where `SYS-` means the harness's own actual
system context. [`ADR-0003`](../adr/0003-run-as-project.md) makes a run a project with its own
chain, so a run allocates **its own prefix**, declared in `RUN.md` at init and unique across
`runs/`:

| In the harness | In a run whose prefix is `STAND-` |
| --- | --- |
| `SYS-001` | `STAND-001` |
| `BLD-001` | `STAND-BLD-001` |
| `ADR-0001` | `STAND-ADR-0001` |

**A bare `SYS-nnn` inside a run's symlinked doctrine always means the harness's entry**, never the
run's — the doctrine is one file at one physical location and its citations resolve there. This is
what makes the two namespaces disjoint, and it is why a run may never allocate `SYS-`.

*Before `ADR-0003` this file instructed every project to allocate `SYS-nnn` in its own
`CONTEXT.md` while itself citing `SYS-001`…`SYS-013` as the harness's. Both meanings, one
namespace, in a file symlinked into every run. Measured once in the first real run, where
`SYS-003` meant "attended by default" in doctrine and something unrelated in the project.*

**Working context deliberately has none**, and that absence is a decision rather than an
omission: *"citing volatile state from a durable record would break the moment the code
moved."* Working context is superseded wave by wave, so nothing durable is allowed to point
at it. What survives from a closed unit is its record, carried in the commit that closed it.

## The two citation forms

A **derived document names its sources at the head.** `BLD-001` opens *"Derives from
`SYS-007`, `SYS-001`."*; `ADR-0002` opens with seven. `build.md`'s own header states the rule
and its penalty: *"Every entry cites the actual-context entries it derives from. **An entry
citing nothing is a defect**, not a shortcut."*

A **decision taken inside a unit of work names its source in brackets**, at the end of a
one-line forensic record, at the site of the decision:

```markdown
## Committed without asking
- <what was chosen> — <the one fact that characterises it> [BLD-014]
```

That bracketed id is the whole mechanism, and [`architect-mode/records.md`](architect-mode/records.md)
is where the form is defined. Note what `ADR-0001` adds to it: *"An id on its own is not a
citation. It asserts coverage and leaves nothing to check."* The line names the entry **and**
the thing that entry ruled out, which is why the format's *one fact that characterises it* is
not filler.

### The `BLD-007` split

Some decisions are authorised by the contract rather than by any context entry. *"Only the
controller may create a unit of work"* is constituted by the tier definitions, and no `SYS-`
or `BLD-` entry reaches it. `BLD-007` settled that the citation names whichever actually
authorised the decision:

| Decision is about | Cites |
| --- | --- |
| **Content** — what gets built, and why this rather than that | The `SYS-`/`BLD-` entry |
| **Process** — who may do a thing, at which tier, in what order | The contract file and section |

`ADR-0002` carries the only worked example: `[architect-mode/context-layers.md, see BLD-007]`.
Nothing is loosened by this. Naming the contract is still a claim anyone can go and check.

## Why the scheme exists

### A citation is a checkable claim

An agent that writes *"derived from `SYS-003`"* has not explained itself — it has made an
assertion, and the point of the assertion is that someone can open `CONTEXT.md` and find out
whether it is true. `context-layers.md` puts it exactly: *"`BLD-003` claiming to derive from
`SYS-002` is a claim anyone can go and check. An interpretation nobody can inspect is
indistinguishable from an invention."* That pair is live — open `docs/context/build.md` and
verify it, which is the whole point.

This matters because derivation is interpretation, and interpretation is where an agent can
rationalise anything. The guard is not restraint. Restraint is unobservable. The guard is
that every derived thing names what it derived from, so the reasoning has a fixed point
outside itself.

So **uncited means unauthorised**, and `records.md` draws the consequence rather than
scolding: *"If you cannot name the entry that authorised it, you did not have authority —
escalate instead of recording."* An agent that cannot find its authority has found a gap,
which is a result, not a failure.

**The dangerous case is not the missing citation.** It is the citation that points at a real
entry which does not actually reach the decision. `BLD-007` states it plainly: that *"is
worse than citing nothing — it reads as derived and passes inspection."* This is the failure
`escalation.md` calls under-escalation, the direction nothing guards live, and it is why
`SYS-007` is worth re-reading alongside it: on a domain you do not know, a bad derivation
*"cites an entry, reads as sound, and cannot be challenged."*

### The chain is traversable in both directions

Forward is the obvious one, and it is what you use when something is wrong: a symptom → the
decision that produced it → the context that permitted that decision → and, where clanker was
involved, the trail entry holding what it knew.

Backward is the one that earns the scheme its keep. From a context entry you now believe is
wrong, you can find **everything built on it** — because everything built on it named it.
`/audit`'s method is literally this: *"Follow each backlink to its `SYS-` entry, then find
everything citing that id: build-context entries, ADRs, forensic lines, and any further trail
entries."* Blast radius is then a count, not a judgement.

That direction is what makes a wrong decision **recoverable rather than merely wrong**. The
repo has already done it once. `SYS-009` — *"nothing arrives from outside"* — arrived after
`ADR-0002` and `BLD-005` were written. Because both cited their sources, the damage was
enumerable: `ADR-0002`'s paragraph reserving a slot for externally-arriving work was struck in
place and marked *"Superseded by `SYS-009`, 2026-08-19"*; `SYS-005` gained a pointer saying its
tracker-reuse clause was closed; `BLD-009` records the three skills that went with it. Nobody
had to re-read the repo to find out what `SYS-009` broke.

### A worked chain

`SYS-010`, top to bottom, is the live one.

1. **`CONTEXT.md`, `SYS-010`.** The architect's words, quoted: *"transcription allowed, but
   only against a record"*. The entry rules out *"an entry here with no verbatim record of the
   decision it claims to transcribe."*
2. **`docs/context/build.md`, `BLD-010`** — *"Derives from `SYS-010`, `SYS-004`, `SYS-006`."*
   It settles what `/context` is: a skill that interviews the architect and transcribes,
   writing nothing it cannot quote. That is one interpretation of `SYS-010`, which is why it
   is build context and not actual context.
3. **`docs/context/working.md`, wave 1, unit *build `/context`*** — *"**Cited.** Derives from
   `BLD-010`, which settles what the skill is."* The unit's *Watch for* names the exact failure
   `SYS-010` exists to prevent: an entry drafted first and fitted with a justifying quote
   afterwards.
4. **The record.** When that unit closes, each decision taken inside it lands as a forensic
   line in the unit's working-context entry, cited, committed in the same commit as the change.
   Working context is then superseded; the commit keeps the record.

Every hop names the one above it. Read it upward from step 4 and you arrive at nine words you
typed. Read it downward from step 1 and you arrive at a file that does not exist yet and the
test it will have to pass.

The chain also carries its own weak points, by id. `SYS-010` names `SYS-006` as *"the weakest
record in this layer"*, and `SYS-006` says so where it sits: *"**Acceptance, not statement.**
The wording of this entry is the agent's, accepted rather than authored."* A record of the form
*"yes"* attests that a choice was made, not what its wording should be. The layer is honest
only while it says which of its entries are like that — and it can say so because the entry has
a name.

### Ids are permanent

`CONTEXT.md`'s header is the rule in one line: *"ids are permanent, and a superseded entry is
struck in place with a pointer to its successor."* Never reused, never renumbered, never
deleted.

Two shapes of this are already in the tree, and they differ on purpose.

- **`SYS-005` was narrowed, not rewritten.** It left wayfinder's retained mechanisms open for
  reuse; `SYS-009` closed the tracker half of that. The entry gained a line — *"Pointer added
  rather than the entry rewritten — the later, more specific entry governs"* — and kept its
  original text.
- **`BLD-005` was superseded with its errors intact.** Its heading reads *"How work enters the
  harness ~~is open~~ — **settled by ADR-0002**"*, and it keeps two claims it got wrong,
  *"because two of its claims were wrong and the record of that matters more than a tidy
  entry."*

What breaks if this is violated is not tidiness. Delete or renumber an entry and every citation
to it becomes a pointer to nothing — or worse, a pointer to something else, so a record now
reads as authorised by a decision nobody took. `/audit` says it directly: deleting an overturned
entry *"orphans every citation and destroys the evidence that a decision was ever taken."* And
rewriting an entry in place to match what you later concluded destroys the thing the whole
scheme exists to preserve: **after that, nothing can tell a deliberate choice from an
accident.**

### The layers only hold because the ids do

The three-layer split is a claim that each layer is derived from the one above it and never
authored from below. That claim is worth something only if it can be checked, and the ids are
the only thing that makes it checkable — an entry that names its source can be verified against
it, and an entry that names nothing is *"either mis-filed or evidence of a derivation nobody
checked; both are defects."*

The same move is made one level higher, where there is no layer above to check against.
`SYS-004` bars agents from writing `CONTEXT.md`; but transcription looks identical to authorship
from outside, and an agent's account of which it was doing is exactly what cannot be trusted. So
`SYS-010` requires the quote. As that entry puts it: **the record is what makes it checkable** —
the same move the citation rule makes for derivations, applied to the one layer that has nothing
above it.

## Where the scheme is weak

Honest inventory of what is currently unenforced or inconsistent. None of it is fatal; all of it
is real.

**Half of a citation is now checked; the important half is not.** `scripts/check-architect-mode.sh`
gained check 10 on 2026-08-19: every `SYS-` and `BLD-` id referenced anywhere in the live
derivation chain must name an entry that exists, so a **dangling** citation now fails the build.
It found three on its first run.

That is the mechanical half. It cannot catch the two that matter more — an entry citing nothing
at all, and a citation to an entry that exists but **does not reach** the decision it is used to
authorise. The second is the dangerous one, because it reads as derived and passes every
inspection. Both need judgement, and the only specified reader is `/audit`, which is built, has
never run, and enters through clanker's trail, which does not exist. Today
the scheme is enforced entirely by whoever is writing.

**Reverse traversal is a grep, and process citations fall outside it.** *"Find everything citing
that id"* works because ids are distinctive strings. `BLD-007`'s process citations name a
contract file and section instead — checkable by a human, invisible to an id-shaped search.
`ADR-0002` also notes that once working context is superseded the traversal has to read git
history rather than the working tree. No tool does either.

**~~The ADR format hands out a citation-free record.~~ Closed 2026-08-19.**
`skills/domain-modeling/ADR-FORMAT.md` is where an agent goes for the
`## Committed without asking` block, and its template omitted the bracketed id entirely while
pointing at the wrong file for the form. Both ADRs in the tree cited correctly anyway — an agent
following the format literally would not have. The template now carries the bracket, says it is
not optional, points at `architect-mode/records.md`, and names the `BLD-007` split.

**~~Illustrative ids sit in the real namespace.~~ Closed 2026-08-19.** Templates used ids from
the ordinary sequence, so a doctrine example would eventually collide with a real entry and read
as citing it. The **`9xx` block of every family is now reserved for illustration** and never
allocated — `records.md` shows `[BLD-901]`, `clanker.md` shows `TRAIL-901 → SYS-902` — and check
10 skips it. Where an example can be real it now is: `context-layers.md` illustrates with a live
pair you can go and verify.

**~~A live miscite under `BLD-007`.~~ Corrected 2026-08-19.** `ADR-0002`'s record line for
where a forensic line is sited is a **process** decision, and it cited `[SYS-005]` — a content
entry about wayfinder's deprecation, which does not reach it. `BLD-007` had grandfathered it
explicitly; it has since been corrected to cite `architect-mode/records.md`.

It is worth keeping the example, because it is the exact failure mode this scheme fears most and
it survived two readings. The citation was plausible — `SYS-005` really is why no ticket is in
the loop — and it still did not authorise the decision it was attached to. **A citation that is
merely relevant is not a citation that authorises**, and nothing mechanical can tell the two
apart. Check 10 would have passed it, because `SYS-005` exists.

**A cited document can go stale with nothing noticing.** `ADR-0001` states that *"when the
architect picks a shape, this ADR is amended to name that one."* You picked shape B; `BLD-008`
records it; `ADR-0001` still presents the choice as open and points at both candidates.
`BLD-008` cites `ADR-0001`, so the link exists — nothing walks it. Same class: `build.md`'s
closing section still says `docs/context/working.md` does not exist, and it now does.

**No allocation mechanism.** The next id is highest-plus-one by inspection. `ADR-FORMAT.md` says
so for ADRs; nothing says it for `SYS-` or `BLD-`. One architect and one controller makes a
collision unlikely rather than impossible, and nothing would detect one. Zero-padding and width
— three digits for `SYS`/`BLD`/`TRAIL`, four for `ADR` — are convention only, as is the link
between `ADR-0002` and the file `0002-work-entry-model.md`.

**`T1`…`T8` are a fifth family and are not citations.** They name the proposed tools and are
used in `BLD-003`, `BLD-005` and `ADR-0002`, but they are defined only in
`rework/tool-specs.md` — a brief whose own header marks it superseded in part, written before
`SYS-001`…`SYS-007` existed. They are shorthand, they are not permanent, and nothing derives
from them. Reading one as authority would be citing a document the tree has already moved past.

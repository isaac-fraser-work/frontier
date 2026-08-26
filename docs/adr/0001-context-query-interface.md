# The query interface for `CONTEXT.md`

> **Shape B was chosen, 2026-08-19**, and `CONTEXT.md` is now written in it. See
> [`BLD-008`](../context/build.md) for the reason: the two candidates hardened opposite steps
> of the lookup, and B makes *covered* the trustworthy verdict, so it fails toward an
> interruption rather than toward a silent misderivation. The candidates in
> [`0001-candidates/`](0001-candidates/) are kept as the record of what was compared —
> `shape-a.md` is **not** a live alternative.

*Derives from `SYS-004`, `SYS-006`, `SYS-008`, via `BLD-004`.*

## Decision

Asking *"does actual system context cover this?"* is **one operation with two steps** — match, then exclude — run over the `SYS-` entries and returning one of three verdicts. Every entry must **harden exactly one of the two steps by declaring it**, and the file hardens the same step throughout. Which step is hardened decides how the file reads and how the architect writes it, so it is theirs; the two files in [`0001-candidates/`](0001-candidates/) are that choice made concrete.

**The choice is made once and the loser is not carried.** `SYS-008` bars a configuration surface, so this is not a setting the lookup branches on: when the architect picks a shape, this ADR is amended to name that one, and an implementation that supports both has kept a preference as an option.

## The lookup

Given a fork, enumerate its candidate answers first — at least two, each stated as a behaviour the system would have rather than as an implementation. An unenumerated fork cannot be looked up, because there is nothing for an entry to exclude.

Then, for each `SYS-` entry, answer two questions in order:

1. **In reach.** Does this entry claim the class of question the fork belongs to?
2. **Excludes.** Applied to each candidate in turn, does it rule that candidate out?

Both are answered from what the entry declares where the shape declares it, and by reading the prose for meaning where it does not. That is the whole content of the shape choice: one step is mechanical, the other is interpretation.

| Result across the entries | Verdict |
| --- | --- |
| An entry excludes at least one candidate and leaves at least one standing | **Covered.** Decide among the survivors — narrowing to two is still covered, and choosing between them is your own layer's. Record with a citation. |
| Entries are in reach, and none excludes any candidate | **Near-miss.** Escalate. Those entries are what the layer says nearest, and naming them is the gap statement's second element. |
| Every candidate is excluded | The enumeration is wrong before the layer is. Re-enumerate once. If nothing survives, **near-miss**, naming the entries that between them left nothing standing. |
| No entry in reach | Read every entry's prose once before concluding. Prose that reaches the fork despite its entry not claiming it → **near-miss**, reported as that entry's declared reach falling short. Otherwise **silent** — escalate as a clean miss. |

**Near-miss and silence are told apart by whether an entry can be named**, not by how close the agent judged it to be. That is the distinction `SYS-006` needs: an agent barred from proposing a filling can still say *"`SYS-002` reaches this and settles nothing in it"*, and naming what the layer says is not proposing what it should say.

## What a citation names

**The entry, and the candidate that entry excluded.** Both halves are checkable by a reader with the file open — whether the entry says what it is claimed to say, and whether it really rules that candidate out.

An id on its own is not a citation. It asserts coverage and leaves nothing to check, and it is exactly the trace [`/audit`](../../skills/audit/SKILL.md) reads for under [under-escalation](../agents/architect-mode/escalation.md). The forensic line in [`records.md`](../agents/architect-mode/records.md) already carries it — *the one fact that characterises it* is the excluded candidate — so no record format changes, and the venue is the one [ADR-0002](0002-work-entry-model.md) settled.

## What `CONTEXT.md` must carry

- A stable id per entry. Already true.
- **One hardened step, the same one throughout** — either a declared reach (the classes of question each entry governs) or declared exclusions (what each entry rules out). Not both: a second declared step is a second thing to keep true and a second place for the two to disagree.

Uniformity is the requirement easiest to miss. The verdicts above classify differently depending on which step is mechanical, so a file that mixes the two makes the answer depend on which entry the agent happened to reach first.

## What it must not require

- **No controlled vocabulary, tags, or taxonomy**, and no ids below the entry.
- **No exhaustiveness.** Reach and exclusion lists are what the architect thought of, never a partition of the space. One that falls short produces an escalation, never a wrong decision.
- **No anticipating forks.** Neither step asks what questions will arrive — reach names a class, exclusions name what was already ruled out in the writing.
- **No precedence, ordering, or cross-links.** Two entries reaching one fork is ordinary.
- **No downstream obligation.** Amending an entry never requires touching what derived from it; finding the stale derivations is `/audit`'s job.
- **No tooling.** Every requirement here has to survive being typed by hand into a file no validator reads, per `SYS-004`.
- **No legibility to a stranger.** `SYS-008` spends nothing on making this file read cold. Reach lines and exclusions are written for the architect and for an agent holding the rest of the repo, and the interface is judged by whether *this* architect keeps it true — not by whether a general author could.

## Considered options

- **Keyword or full-text search over the prose.** Rejected: it contradicts *derive for meaning, not for letter*. A fork whose words do not appear reads as silent when the intent plainly reaches it, and a word match is not a reach claim, so the citation it produces is unverifiable.
- **Free interpretation — read the file, form a judgement.** This is the status quo and it is the judgement call `BLD-004` exists to remove. Nothing separates covered from near-miss, so the two collapse, and under `SYS-006` an agent that cannot tell them apart escalates everything or under-escalates silently.
- **A structured schema — frontmatter, tags, a decision table.** Rejected on `SYS-004`: only a generator keeps it valid, and a schema that decays the first time a human edits it by hand is a failed design.
- **A question-indexed document — `CONTEXT.md` as questions and their answers.** The crispest lookup available, and rejected because it requires the architect to anticipate forks, which they do not do. An unanticipated question then reads as silence with no entry to name. Candidate B moves partway toward this deliberately, so the cost is visible rather than argued.
- **A confidence score with an escalation threshold.** Rejected: it reintroduces the introspection the tier-crossing test replaced. A threshold is a coin flip with a number on it, and a reader cannot check a score.

## Consequences

- **Coverage and silence are not equally trustworthy, and which one is soft follows from the shape.** Hardening the match step makes *silent* the reliable verdict and *covered* the arguable one, so the failure is a false covered — under-escalation. Hardening the exclude step reverses it: *covered* becomes reliable and *silent* arguable, and the failure is the architect answering a question the layer already answered. Both candidates carry this, in opposite directions.
- **All eight current entries already exclude something** — `SYS-001` a target artifact, `SYS-002` the better-results argument, `SYS-003` degrading to unattended, `SYS-004` an inferred clanker licence, `SYS-005` wayfinder as method, `SYS-006` a suggested filling, `SYS-007` a second project on this file, `SYS-008` a second user and a configuration surface. The requirement is not new work in kind.
- **An entry that excludes nothing anywhere in its reach is a near-miss generator.** It will be named in escalations and never settle one. That is a property the architect will feel, not a rule imposed on them.
- **A declared reach is never cited alone.** It gates the match and decides nothing; an entry cited without a named excluded candidate has been cited on its index.
- **The interruption rate keeps meaning what `architect-mode.md` says it means.** Reach and exclusions that fall short degrade toward escalation, so incompleteness in the file surfaces as interruptions rather than as decisions.

## Committed without asking

- Uniform hardening across the file rather than per entry — a mixed file makes the verdict depend on which entry was reached first [BLD-004]
- The no-entry-in-reach branch reads every entry's prose before returning silent — a declared reach that falls short would otherwise report a near-miss as a clean miss [SYS-006]
- Two entries that between them exclude every candidate classified as near-miss, not a fourth verdict — a layer that leaves nothing standing has not settled the fork [SYS-006]
- One hardened step required, not both — candidate B declares exclusions and no reach, so requiring both would have taken the architect's choice here [BLD-004]
- The shape choice closed once rather than supported as an option — a lookup that branches on shape is the configuration surface `SYS-008` bars [SYS-008]
- No change to the forensic line — its *one fact that characterises it* is already the excluded candidate [BLD-004]

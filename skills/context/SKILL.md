---
name: context
description: Interview the architect and record what they decide as actual system context. Only they decide; this writes down what they said, quoted.
---

Work in **architect mode** throughout: read `docs/agents/architect-mode.md` and follow it for every question you ask, every decision you take without asking, and the shape of every response. It governs where it conflicts with anything below.

This skill writes `CONTEXT.md`, the one layer with nothing above it to check it against. Read `docs/agents/architect-mode/context-layers.md` before the first entry.

## Purpose

Fill actual system context by interviewing the architect, and write down what they decide — **quoted**.

You are not a co-author. Every word of judgement in that file is theirs; every word of yours is transcription. The distinction is invisible from outside, because both produce an entry attributed to them, so it is made checkable instead: **an entry exists only with their own words quoted verbatim above it.**

No record, no entry. That is not a guideline you weigh against getting the file written.

## The one rule that makes this safe

**The quote comes first.**

Write the record, then the entry from it. Never the entry, then a quote that supports it.

The second reads identically to the first once committed — attributed, sourced, checkable — and it is authorship wearing the costume of transcription. It is the same failure `/audit` exists to catch one layer down, arrived at the layer where nothing downstream can catch it, because everything downstream will have been derived from it and will agree.

If you find yourself looking back through the conversation for something that supports an entry you have already drafted, **stop and delete the draft.** Ask instead.

## What you may write, and what you may not

| | |
| --- | --- |
| **May** | Type up a decision they have taken, quoted verbatim |
| **May** | Shape their words into the entry format below, preserving meaning exactly |
| **May not** | Decide what an entry says |
| **May not** | Fill a gap, or suggest what filling it would say — see `SYS-006` |
| **May not** | Extend an entry past what the quote reaches. That excess is authored |
| **May not** | Tidy, correct, complete or de-typo a quote. It is as typed or it is not a record |
| **May not** | Fill a `Leaves open` line. Blank is a valid state and it is theirs |

Where they answer by accepting something you proposed — *"yes"*, *"agreed"*, *"do that"* — the record attests **that a choice was made, not what its wording should be.** The wording is then yours. Say so in the entry, in place. `SYS-006` is the worked example.

## Method

1. **Read `CONTEXT.md` first**, all of it. You are looking for what is already settled, and for `Leaves open` lines — a blank there is often the sharpest question available.

   **If it does not exist, say so and carry on** — this is a first run and the file is created by the first entry you write, not scaffolded ahead of it (`SYS-004`). Say it out loud rather than proceeding quietly: nothing downstream can derive from an absent layer 1, and a run that reports *nothing to do* without reporting *because the chain is empty* is the failure `domain.md` used to cause.

2. **Interview via `/grilling`.** Relentless about purpose, never about detail. Their decisions are the ones this layer has to answer; everything else is yours or the controller's and does not belong in the interview.

3. **Put gaps, not questions.** A gap is what could not be decided, what this context says nearest to it, and the behavioural contrast between the ways it could be filled. Never a suggested filling. See `docs/agents/architect-mode/escalation.md`.

4. **Capture the answer verbatim as they give it.** Before writing anything, have the exact words. If you cannot quote it, you have not got a decision yet — go back.

5. **Write the entry from the record**, in the format below, allocating the next id in sequence. Ids are permanent: never reused, never renumbered.

6. **Run `scripts/check-architect-mode.sh`.** Check 11 fails the build on any entry without a record; check 10 fails on any citation naming an entry that does not exist. Both are what this skill is judged by, not a formality after it.

7. **Report what was written**, per `SYS-011`.

## Entry format

Shape B, fixed by `BLD-008` and specified in `docs/adr/0001-context-query-interface.md`. Its logic: the **rule** and the **exclusions** settle a question; the reasoning is read for meaning and never on its own grounds to rule anything out.

**The prefix is the run's, not `SYS-`.** In the harness itself entries are `SYS-nnn`. In any scaffolded run, `RUN.md` declares that run's prefix and every entry carries it — `STAND-001`, not `SYS-001` ([`ADR-0003`](../../docs/adr/0003-run-as-project.md)). Read `RUN.md` before allocating. A run that allocates `SYS-` collides head-on with the doctrine symlinked into it, where those ids already mean the harness's own entries; that collision was measured in the first real run and is why the prefix exists. Substitute the run's prefix for `SYS` throughout the template below.

```markdown
## SYS-0nn — <the rule in one line, in their terms>

*Architect, <date>.*

**Record** (`SYS-010`), verbatim:

> <their exact words>

**Interpretation** (`SYS-019`), the agent's, marked as such. <the reading taken of the record, and
the circumstances it was given in: what was being decided, what had just been established, what
question was on the table. If the record is an **acceptance of a framing you worded** rather than
the architect's own statement, say so here — `SYS-006`.>

<the rule, stated>

**Rules out.**

- <what this forbids, one per line, each checkable>

**Leaves open.** <what it deliberately does not settle — or "Not declared">

**Why.** <the reasoning, demoted>
```

**The interpretation is mandatory and it is yours** (`SYS-019`). Two things, separately and both
visible: their words as said, and the reading you took of them **in the context in which they were
said**. A rule stated without its interpretation can only be obeyed or broken; stated with it, it
can be found to have been read wrongly — which is the only correction available in a layer with
nothing above it.

It is a reading of the record, **never an addition to it**. If your interpretation reaches
something the quote does not, the excess is authored and belongs nowhere.

Applies from `SYS-017` onward. Whether the sixteen entries before it are retrofitted is
**undeclared** and is the architect's (`SYS-019`, *Leaves open*) — do not backfill them.

**`Rules out` is where the entry earns its place.** It is what makes a lookup answerable: an agent asks whether this entry excludes a candidate, and a listed exclusion answers yes or no without interpretation. An entry with a vague rule and a rich `Why` is prose that cannot be queried.

**Do not manufacture exclusions.** List what the quote reaches. If it reaches one thing, list one.

## When the architect is not there

Hold. `SYS-003` makes attendance the default and a run with nobody to answer stops — stopping is how the gap becomes visible.

Do not hand the work to `clanker`. Its licence is granted per invocation by the architect and is never inferred from their absence; concluding that conditions warrant it is itself a decision only they may take.

## Good enough does not apply

Architect mode's *Good enough* clause licenses **a** coherent system over the correct one where work is creating something that does not exist yet. This is not that. A wrong entry here is not cheap to find in use — every later derivation cites it and agrees with it, which is precisely why the record exists.

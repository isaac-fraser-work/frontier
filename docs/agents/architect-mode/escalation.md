# Escalation

How a decision moves up the tiers. Read [`../architect-mode.md`](../architect-mode.md) first — this file is the protocol.

## The chain

A fork arrives at the tier that hit it. Each stage either answers it or passes a **gap** upward, reframed.

1. **Subagent** queries working context. Covered → decide, record, proceed. Not covered → escalate.
2. **Controller** queries build context. Covered → decide, push the answer down, record.
3. **Controller** attempts derivation from actual context. Derivable → write the new build entry, decide, record.
4. **Not derivable** → the actual system context underdetermines it. Escalate to the architect as a gap in *their* context.
5. **Architect** extends actual context. The controller re-derives build context and the decision falls out of it.

Most escalations die at stage 2 or 3. That is the point: **the controller absorbs the volume, and the architect sees only genuine holes in what they have said.**

## Reframe at every hop

An escalation carries a gap, never the raw question. Each hop restates it in the vocabulary of the tier receiving it — a subagent's question in build terms, a controller's question in system terms.

> **Subagent:** "Should this be a queue or a channel?"
> **Controller receives:** "Build context does not specify delivery ordering."
> **Architect receives:** "Must messages arrive in the order they were sent, or is newest-wins acceptable? Ordered means a slow consumer holds up everyone behind it; newest-wins means a slow consumer silently misses updates."

Passing the raw question through is the failure that rebuilds the exact problem this contract exists to solve, with more machinery in the way. **A controller that forwards a subagent's vocabulary to the architect has not escalated — it has abdicated.**

## What a gap statement contains

Three things, and nothing else:

- **What could not be decided**, in the receiving tier's terms.
- **What the layer does say** that is nearest to it — so the architect can see the shape of the hole rather than being asked cold.
- **The behavioural contrast** between the ways it could be filled.

No implementation detail, no options list without consequences, no request for permission.

## Throttling

Escalation is cheap and diagnostic, so escalating on genuine ambiguity is correct. It is not licence to escalate on every fork.

- **Do not escalate a means.** If your layer answers *what* and you are choosing between equivalent ways to express it, that is yours.
- **Do not escalate twice.** A gap filled once is a context entry; the next agent to hit the same fork reads it. If you are escalating something already answered, you did not query properly.
- **Batch at the boundary.** A controller holding several architect-bound gaps puts them in one exchange, numbered, each with its own contrast — not one interruption per gap.

## When the architect is absent

Stage 4 terminates at the architect, and if they are not there to answer it, **the wave holds**. That is the only default. Surface the gap, stop, and wait.

There is no second disposition the controller may select. [Clanker](clanker.md) can take stage 4 — but only for a run the architect explicitly launched it for, and the controller never promotes it on its own. **Inferring clanker's licence from a run's conditions is the failure mode**, not the fallback: it would let the tier that cannot write actual system context decide when an agent writes it instead, which is the derivation rule defeated by procedure rather than by edit.

So a stalled run is a correct outcome. An unattended run that hits an unclanked stage 4 stops with the gap stated, and stopping is what makes the gap visible.

## Under-escalation is the unguarded direction

The throttling rules above guard against escalating too much. Nothing guards the other way, and it is the more dangerous one: a controller that resolves at build tier something the actual system context genuinely underdetermines produces a decision that looks derived, cites an entry that does not really cover it, and is consistent with everything built after it.

There is no live check for this. The guard is retrospective and it is the citation — a build entry whose cited actual-context entry does not actually reach the question is the trace, and reading for that is `/audit`'s job, not only clanker's trail.

Since the architect is present by default, the cost of escalating one time too many is an interruption. The cost of escalating one time too few is a silent misderivation. **Prefer the interruption.**

# Clanker

The one agent licensed to write actual system context in the architect's place. Read [`../architect-mode.md`](../architect-mode.md) and [`context-layers.md`](context-layers.md) first.

## Why it exists

Escalation terminates at the architect, and when they are not there the run holds. Clanker is how the architect **delegates** a stretch of that answering — deliberately, for a run they chose to hand over — and pays for it with a trail dense enough to unwind any decision it took.

It is not a fallback for their absence. Absence is handled by stopping.

## The grant, and its bounds

**Clanker writes `CONTEXT.md`. Nothing else.** It does not derive build context, does not orchestrate, does not touch code. It answers gaps the controller could not derive, and hands control straight back.

**The licence is granted per invocation, by the architect, and by nobody else.** It is not inferred from a run being long, unattended, or blocked, and no agent may conclude that conditions warrant it. A controller that reaches stage 4 without clanker having been explicitly invoked holds the wave; it does not summon one. The architect is the only definer of actual system context, and clanker is that authority lent out on purpose, not a standing deputy.

Within an invocation it commits directly — no review gate, no provisional state. That is a deliberate choice: a gated clanker cannot complete the run it was called for, which is the only reason it exists. **The trail is the entire safety mechanism**, which is why its obligations below are absolute rather than best-effort.

Every entry it writes is marked as clanker-authored and carries a backlink to its trail entry. An architect reviewing later can filter `CONTEXT.md` to exactly what was decided in their absence.

## Obligations

Non-negotiable. A decision taken without these is a defect regardless of whether it was correct.

1. **One trail entry per decision**, appended to `docs/context/trail.md`, never amended and never reordered.
2. **Backlink both ways** — the trail entry names the `SYS-` id it created; the `CONTEXT.md` entry names the trail entry.
3. **Record what it knew, not what it concluded.** Sources consulted, what they said, what was ruled out and why. The conclusion is already in `CONTEXT.md`; the trail exists for everything that led there.
4. **Name the gap that prompted it** — the escalation it was answering, in the form it arrived.

```markdown
## TRAIL-901 → SYS-902
**Gap:** <the escalation, as received>
**Decided:** <the entry written to CONTEXT.md>
**Knew:** <what was consulted, and what each source established>
**Ruled out:** <the readings rejected, and what made them wrong>
```

## Research, not invention

Clanker is a research agent with commit authority — `/research` plus the licence to act on what it finds. Its decisions are grounded in sources it can name, and a trail entry whose **Knew** section cites nothing is clanker guessing.

Where no source settles the question, clanker records the gap as **unresolved** rather than inventing an answer, and the controller routes around it or holds the wave. Inventing actual system context is the one failure that cannot be caught downstream, because every later decision will be consistent with the invention.

## Review

The `/audit` skill performs this, and it is the **mandatory close-out of any run clanker was invoked for** — clanker's authority is granted on the condition that something collects on the trail afterwards.

It separates entries clanker invented from entries since superseded from entries that are sound but not what the architect wanted, because only the last of those needs the architect at all. Overturned entries are superseded in place, never deleted, and everything citing them is re-derived rather than merely reviewed.

## Prerequisite

Clanker's defining capability is external research, and this repo's sandbox currently sets `network.allowedDomains` to `[]` with `failIfUnavailable: true`. **Clanker cannot run under the current configuration.** The environment assessor is what catches this class of problem before an unattended run starts, rather than after it has silently stalled.

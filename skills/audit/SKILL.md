---
name: audit
description: Audit the system context an agent decided in your absence — which entries still hold, which were guesses, and what got built on the ones that were wrong.
---

Work in **architect mode** throughout: read `docs/agents/architect-mode.md` and follow it for every question you ask, every decision you take without asking, and the shape of every response. It governs where it conflicts with anything below.

An unattended run leaves behind actual system context that the architect never wrote. `clanker` — see `docs/agents/architect-mode/clanker.md` — commits those entries directly, with no review gate, and pays for that authority with a trail dense enough to unwind any of them. **This skill is what collects.** Without it the trail is write-only, and a paper trail nobody reads is the same as no paper trail.

Architect mode's *Good enough* clause does **not** apply here. This judges correctness against work already produced.

## Purpose

Determine, cheaply, **which of the decisions taken in the architect's absence still hold** — without re-deriving the system, and without spending the architect's attention on entries that can be settled without them.

That last clause is the design. A long run can leave dozens of entries; putting all of them to the architect would cost more than the run saved. Most can be judged against evidence already in the repo. Only one of the three failure modes below needs a human at all.

## The three failure modes

Every trail entry is exactly one of these, and they are separated because each has a different judge and a different remedy.

| | What went wrong | Judged by | Remedy |
| --- | --- | --- | --- |
| **Invented** | The entry's **Knew** section cites nothing, or cites sources that don't establish what was concluded. Clanker guessed. | You, alone | Report for overturn — an invention has no claim to stand |
| **Superseded** | What clanker knew was true then and isn't now — a source changed, or a later decision contradicts it. | You, alone | Report for overturn, or for narrowing to what still holds |
| **Misaligned** | Well-researched, internally consistent, and **not what the architect would have wanted.** | The architect, only | Theirs to keep or overturn |

Nothing in the repo can detect misalignment, because every artifact downstream was derived *from* the entry and will agree with it. That is the one class worth interrupting for.

## Method

Run the two AFK passes to completion before putting anything to the architect. A misalignment question is wasted if the entry turns out to have been an invention.

1. **Read `docs/context/trail.md` in order.** Chronological, because later entries may have been decided on the strength of earlier ones — an overturned entry can invalidate the ones that followed it, and only the order shows you that.
2. **Follow each backlink** to its `SYS-` entry, then find everything citing that id: build-context entries, ADRs, forensic lines, and any further trail entries.
3. **Compute blast radius** — how much was built on the entry. This is the ranking key throughout. A wrong entry nothing depends on is a footnote; a wrong entry with forty citations is the finding, and reporting them in trail order rather than blast-radius order buries it.
4. **Classify** each entry against the table above. Where the classification is itself uncertain, treat it as misaligned and let the architect decide — an agent adjudicating whether an agent's research was sound is the one judgement here you should not trust yourself with.
5. **Put the misaligned set to the architect**, ranked by blast radius, in architect register: what was decided, what the alternative was, and what each means for how the system behaves. Never what clanker read, never how it reasoned — that is background and belongs behind the architect view.

## Output

- **You classify and report; the architect writes.** `SYS-004` grants writing `CONTEXT.md` to clanker alone, and you are what collects on clanker — not a second holder of its licence. Every remedy below is something you hand over, never something you apply.
- **Overturned entries are superseded in place, never deleted.** The architect strikes the `SYS-` entry and leaves it with a pointer to its replacement. Deleting it orphans every citation and destroys the evidence that a decision was ever taken — the same failure as editing a layer from below.
- **One unit of work per overturned entry** (`ADR-0002`), carrying its blast radius and the list of everything that cites it. Each of those citations is a derivation built on a premise that no longer holds and has to be re-derived, not merely reviewed.
- **A `## Committed without asking` record** for every classification you settled alone, citing the trail entry it judged.
- **Entries that survive are marked as reviewed**, with the date. An entry reviewed once and unchanged since is not re-litigated on the next run; re-auditing settled entries is how this skill turns into the very cost it exists to avoid.

## When it runs

**At the close of every unattended run**, before the result is handed back. This is the point of the tool: the architect returns to a system that has already told them which of its own decisions it is least sure of, ranked by what depends on them.

It is user-invocable at any time, and worth running after any stretch where the architect was absent rather than merely quiet.

If `docs/context/trail.md` does not exist, no agent has written actual system context here. Say so and stop — there is nothing to audit, and that is a clean result rather than a missing input.
